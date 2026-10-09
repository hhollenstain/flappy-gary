extends Node2D

# Main game controller for Flappy Gary
# This script will handle the core gameplay mechanics

@export var gravity: float = 500.0
@export var jump_force: float = -300.0
@export var game_speed: float = 100.0

var player_velocity: Vector2 = Vector2.ZERO
var is_game_over: bool = false
var score: int = 0

@onready var player = $GameArea/Player
@onready var game_area = $GameArea

func _ready():
	# Initialize the game
	print("Flappy Gary game ready!")
	_initialize_game()

func _initialize_game():
	# Reset game state
	player_velocity = Vector2.ZERO
	is_game_over = false
	score = 0
	
	# Position player at start
	player.position = Vector2(100, 300)

func _process(delta):
	if not is_game_over:
		# Apply gravity
		player_velocity.y += gravity * delta
		
		# Update player position
		player.position += player_velocity * delta
		
		# Check for game over conditions
		check_game_over()

func _input(event):
	if event.is_action_pressed("click") and not is_game_over:
		jump()
	elif event.is_action_pressed("restart") and is_game_over:
		restart_game()

func jump():
	player_velocity.y = jump_force

func check_game_over():
	# Check if player hits ground or ceiling
	if player.position.y >= 600 or player.position.y <= 0:
		game_over()
		
	# Check for collision with obstacles (to be implemented)

func game_over():
	is_game_over = true
	print("Game Over! Final Score: ", score)
	
	# Display game over screen (to be implemented)

func restart_game():
	_initialize_game()

func _on_Score_Timer_timeout():
	if not is_game_over:
		score += 1
		print("Score: ", score)