extends CharacterBody2D

# Player physics and movement for Flappy Gary
@export var gravity = 1500.0
@export var jump_force = -500.0

signal player_ready
signal game_over

func _ready():
	velocity = Vector2(0, 0)
	player_ready.emit()

func _physics_process(delta):
	# Apply gravity when not grounded
	if not is_on_floor() and not is_on_ceiling():
		velocity.y += gravity * delta
	
	# Move the player
	move_and_slide()
	
	# Check for ground collision (game over)
	if is_on_floor() and velocity.y > 0:
		game_over.emit()
	
	# Check for ceiling collision (game over)
	if is_on_ceiling() and velocity.y < 0:
		game_over.emit()

func jump():
	# Replace vertical speed so every flap climbs, even after earlier falls.
	velocity.y = jump_force