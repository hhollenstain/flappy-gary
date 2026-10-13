extends Sprite2D

# Player physics and movement for Flappy Gary
@export var gravity = 500.0
@export var jump_force = -300.0
@export var velocity = Vector2(0, 0)

func _ready():
	# Initialize player physics
	pass

func _process(delta):
	# Apply gravity
	velocity.y += gravity * delta
	
	# Update position
	position += velocity * delta
	
	# Check for collisions with ground and ceiling (this is basic - real game would use collision shapes)
	if position.y >= 600:  # Ground collision
		position.y = 600
		velocity.y = 0
	
	if position.y <= 0:  # Ceiling collision
		position.y = 0
		velocity.y = 0

func jump():
	velocity.y = jump_force

func _input(event):
	if event.is_action_just_pressed("ui_select"):
		jump()