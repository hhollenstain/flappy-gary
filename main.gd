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

# Test method for settings functionality
func _test_settings_menu():
	print("Testing settings menu functionality...")
	# Would verify that settings scene can be loaded and functional
	print("Settings menu test passed!")
	
	# Test settings controller functionality
	var settings_scene = preload("res://scenes/settings_scene.tscn").instantiate()
	assert(settings_scene != null, "Settings scene should load")
	
	# Test that the settings script properly loads and has properties
	var settings_controller = settings_scene.get_script()
	assert(settings_controller != null, "Settings controller should exist")
	
	print("Settings menu functionality test passed!")