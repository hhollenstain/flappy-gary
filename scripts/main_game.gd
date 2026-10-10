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

func _ready():
	print("Flappy Gary game ready!")
	_initialize_game()

func _initialize_game():
	score = 0
	game_over = false
	level = 1
	$Player.position = Vector2(100, 300)
	$ScoreLabel.text = "Score: 0"
	
	# Clear existing pipes
	for pipe in pipes:
		if pipe != null and pipe.is_inside_tree():
			pipe.queue_free()
	pipes.clear()
	
	# Reset timer
	pipe_timer = 0

func _process(delta):
	if not game_over:
		# Apply gravity
		$Player.position.y += gravity * delta
		
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
	if $Player.position.y >= 600 or $Player.position.y <= 0:
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

func _input(event):
	if event.is_action_just_pressed("ui_select"):
		if not game_over:
			$Player.position.y += jump_force
		elif game_over:
			# Restart when game over and space is pressed
			_initialize_game()

func show_game_over():
	print("Game Over! Final Score: ", score)
	get_tree().change_scene_to_file("res://scenes/game_over_scene.tscn")