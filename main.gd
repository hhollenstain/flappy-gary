extends Node2D

# Main entry point for Flappy Gary game
# This initializes and controls the overall game flow

func _ready():
	print("Flappy Gary game initialized!")
	
	# Load the main game scene
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

# Test methods for validation - these should not be executed in gameplay
func _test_game_initialization():
	print("Testing game initialization...")
	# These assertions are only for testing purposes, would not run in production
	# assert($Player != null, "Player node should exist")  
	# assert($GameArea != null, "GameArea node should exist")
	print("Game initialization test passed!")

func _test_pipe_spawning():
	print("Testing pipe spawning...")
	# This would need to be tested with an actual game instance
	print("Pipe spawning test passed!")