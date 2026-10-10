extends Node2D

# Main gameplay script for Flappy Gary
class_name MainGame

var score = 0
var game_over = false
var level = 1
var pipes = [] # Keep track of pipes for collision detection
var pipe_timer = 0
var pipe_interval = 1.5 # Time between pipe spawns in seconds
var gravity = 500.0
var jump_force = -300.0
var level_manager = null
var passed_pipes = 0 # Keep track of pipes passed for scoring
var player_velocity = Vector2(0, 0)
var ground_position = 600

func _ready():
	print("Flappy Gary game ready!")
	_initialize_game()

func _initialize_game():
	score = 0
	game_over = false
	level = 1
	passed_pipes = 0
	$Player.position = Vector2(100, 300)
	$Player.position.y = 300 # Set initial position
	player_velocity = Vector2(0, 0) # Reset velocity
	$ScoreLabel.text = "Score: 0"
	$LevelLabel.text = "Level: 1"
	
	# Clear existing pipes
	for pipe in pipes:
		if pipe != null and pipe.is_inside_tree():
			pipe.queue_free()
	pipes.clear()
	
	# Reset timer
	pipe_timer = 0
	
	# Initialize or get level manager
	if level_manager == null:
		level_manager = preload("res://scripts/level.gd").new()
		level_manager.current_level = 1

func _process(delta):
	if not game_over:
		# Apply gravity to velocity
		player_velocity.y += gravity * delta
		$Player.position += player_velocity * delta
		
		# Update pipe timer and spawn pipes
		pipe_timer += delta
		if pipe_timer >= pipe_interval:
			spawn_pipe()
			pipe_timer = 0
			
		# Check for collisions with pipes, ground or ceiling
		check_collisions()
	
	elif game_over:
		# Allow restart on tap even if game over  
		if Input.is_action_just_pressed("ui_select"):
			_initialize_game()

func spawn_pipe():
	var pipe = preload("res://scenes/pipe.tscn").instantiate()
	pipe.position.x = 800 # Start off-screen to the right
	pipe.position.y = randf_range(150, 450) # Random vertical position
	add_child(pipe)
	pipes.append(pipe)

func check_collisions():
	# Check ground and ceiling collision
	if $Player.position.y >= ground_position || $Player.position.y <= 0:
		game_over = true
		show_game_over()
		return
		
	# Check collision with pipes using proper Area2D collision
	for pipe in pipes:
		if pipe != null and pipe.is_inside_tree():
			var player_rect = $Player.get_global_rect()
			# We'll do basic intersection check for now (more complex logic can be added later)
			if player_rect.intersects(pipe.get_global_rect()):
				game_over = true
				show_game_over()
				return

func _input(event):
	if event.is_action_just_pressed("ui_select"):
		if not game_over:
			player_velocity.y = jump_force # Apply upward force
		elif game_over:
			# Restart when game over and space is pressed
			_initialize_game()

func show_game_over():
	print("Game Over! Final Score: ", score)
	var scene = get_tree().change_scene_to_file("res://scenes/game_over_scene.tscn")
	var game_over_scene = get_tree().current_scene
	if game_over_scene != null and game_over_scene.has_method("set_final_score"):
		game_over_scene.set_final_score(score)

func update_score(points: int):
	score += points
	$ScoreLabel.text = "Score: " + str(score)
	
	# Check if we should level up - every 100 points
	if score >= level * 100:
		increment_level()

func increment_level():
	level += 1
	pipe_interval = max(0.5, pipe_interval - 0.1)  # Speed up pipes slightly each level  
	gravity = gravity + 20.0  # Increase gravity for more difficulty
	
	# Update UI to show level
	if $LevelLabel:
		$LevelLabel.text = "Level: " + str(level)
	
	print("Level Up! Now at Level ", level)

# Function called when a pipe is passed to update score
func on_pipe_passed():
	passed_pipes += 1
	update_score(10) # Give 10 points for passing a pipe

func get_level() -> int:
	return level

func get_score() -> int:
	return score