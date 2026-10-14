extends Node2D

# Main gameplay script for Flappy Gary
# This script manages the core game logic and handles signal connections.
# Signal connections are used to coordinate between different components:
# - Player input handling (via _input function)
# - Game state management (game over, restart, initialization)  
# - Score and level updates (via update_score and increment_level functions)
# - Pipe passing detection (via on_pipe_passed function)
class_name MainGame

@export var score = 0
@export var game_over = false
@export var level = 1
@export var pipes = []
@export var pipe_timer = 0
@export var pipe_interval = 1.5
@export var level_manager = null
@export var passed_pipes = 0
@export var ground_Y = 560
var _game_over_shown := false

# Bottom of the playfield. Player physics live on the Player node only.
var ground_position: float = 560.0

func _ready():
	# Signal connection: This function initializes the game and sets up initial state
	# Connected to scene ready event when the game starts
	print("Flappy Gary game ready!")
	_initialize_game()

func _initialize_game():
	score = 0
	game_over = false
	_game_over_shown = false
	level = 1
	passed_pipes = 0
	if has_node("Player"):
		$Player.position = Vector2(100, 300)
		if $Player is CharacterBody2D:
			$Player.velocity = Vector2(0, 0)
	if has_node("UI/ScoreLabel"):
		$UI/ScoreLabel.text = "Score: 0"
	if has_node("UI/LevelLabel"):
		$UI/LevelLabel.text = "Level: 1"
	
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

	# Connect player signals
	if get_tree() and has_node("Player"):
		$Player.player_ready.connect(_on_player_ready)
		$Player.game_over.connect(_on_player_game_over)

func _process(delta):
	if not game_over:
		if has_node("Player"):
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
	var kinds := ["top", "bottom", "both"]
	return spawn_pipe_of(kinds[randi() % kinds.size()])

func spawn_pipe_of(kind: String, opening: float = -1.0):
	var pipe = preload("res://scenes/pipe.tscn").instantiate()
	pipe.setup(kind, opening)
	pipe.position = Vector2(860, 0)
	add_child(pipe)
	pipes.append(pipe)
	return pipe

func check_collisions():
	# Check ground and ceiling collision
	if has_node("Player"):
		if $Player.position.y >= ground_position || $Player.position.y <= 0:
			game_over = true
			show_game_over()
			return

		for pipe in pipes:
			if _pipe_alive(pipe) and pipe.hits_body($Player):
				game_over = true
				show_game_over()
				return
		for pipe in pipes:
			if _pipe_alive(pipe) and pipe.poll_passed($Player.position.x):
				on_pipe_passed()

func _pipe_alive(pipe) -> bool:
	return pipe != null and is_instance_valid(pipe) and pipe.is_inside_tree()

func _input(event):
	# Signal connection: This function handles player input events
	# Connected to the Input event system for jump actions
	if event is InputEvent:
		if Input.is_action_just_pressed("ui_select"):
			if not game_over:
				if $Player:
					$Player.jump() # Apply upward force
			elif game_over:
				# Restart when game over and space is pressed
				_initialize_game()

func show_game_over():
	# Signal connection: This function triggers the game over state
	# Should be connected to collision detection or game over conditions
	if _game_over_shown:
		return
	_game_over_shown = true
	print("Game Over! Final Score: ", score)
	if get_tree():
		get_tree().set_meta("final_score", score)
		get_tree().change_scene_to_file("res://scenes/game_over_scene.tscn")

func update_score(points: int):
	# Signal connection: This function updates the score display and can trigger level up
	# Should be connected to pipe passing events or scoring signals
	score += points
	if has_node("UI/ScoreLabel"):
		$UI/ScoreLabel.text = "Score: " + str(score)
	
	# Check if we should level up - every 100 points
	if score >= level * 100:
		increment_level()

func increment_level():
	# Signal connection: This function handles level progression and difficulty adjustments
	# Should be connected to score update signals or level up events
	level += 1
	pipe_interval = max(0.5, pipe_interval - 0.1)  # Speed up pipes slightly each level
	if has_node("Player"):
		$Player.gravity += 20.0

	# Update UI to show level
	if has_node("UI/LevelLabel"):
		$UI/LevelLabel.text = "Level: " + str(level)
	
	print("Level Up! Now at Level ", level)

# Function called when a pipe is passed to update score
# Signal connection: This function should be connected to pipe passed signals from pipe scenes
func on_pipe_passed():
	passed_pipes += 1
	update_score(10) # Give 10 points for passing a pipe

func get_level() -> int:
	return level

func get_score() -> int:
	return score

func _on_player_ready():
	print("Player is ready for gameplay!")

func _on_player_game_over():
	game_over = true
	show_game_over()
