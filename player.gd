extends CharacterBody2D

# Player physics and movement for Flappy Gary
@export var gravity = 1500.0
@export var jump_force = -400.0

signal player_ready
signal game_over

func _ready():
	velocity = Vector2(0, 0)
	player_ready.emit()

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor() and not is_on_ceiling():
		velocity.y += gravity * delta
	
	# Move the player
	move_and_slide()
	
	# Check for ground collision (game over)
	if is_on_floor() and velocity.y >= 0:
		game_over.emit()
	
	# Check for ceiling collision (game over)
	if is_on_ceiling():
		game_over.emit()

func jump():
	velocity.y = jump_force

func _input(event):
	if event is InputEvent and event.is_action_pressed("ui_select"):
		jump()
