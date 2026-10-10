extends Node2D

@export var speed := 200.0
@export var passed = false # To track if this pipe has been passed

func _process(delta: float) -> void:
	position.x -= speed * delta
	
	# Check if pipe has moved off screen
	if position.x < -100.0:
		queue_free()
	
	# Check if player passed this pipe (only once)
	if not passed and position.x < 100: # Player is at x=100
		var main_game = get_tree().get_root().find_node("MainGame", true, false)
		if main_game != null and main_game.has_method("on_pipe_passed"):
			main_game.on_pipe_passed()
			passed = true
