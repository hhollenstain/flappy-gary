extends Node2D

# Main gameplay script for Flappy Gary

var score = 0
var game_over = false
var pipes = [] # Keep track of pipes for collision detection
var pipe_timer = 0
var pipe_interval = 1.5 # Time between pipe spawns in seconds

func _ready():
	print("Flappy Gary game ready!")
	_initialize_game()

func _initialize_game():
	score = 0
	game_over = false
	$Player.position = Vector2(100, 300)
	
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
		$Player.position.y += 500 * delta
		
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
		
	# Simple collision detection with pipes - this is a basic approach
	# A proper implementation would use areas/trigger collisions
	var player_rect = $Player.get_global_rect()
	
	for pipe in pipes:
		if pipe != null and pipe.is_inside_tree():
			# Check if player intersects with pipe area
			if player_rect.intersects(pipe.get_global_rect()):
				game_over = true
				show_game_over()

func _input(event):
	if event.is_action_just_pressed("ui_select"):
		if not game_over:
			$Player.position.y -= 300

func show_game_over():
	print("Game Over! Final Score: ", score)