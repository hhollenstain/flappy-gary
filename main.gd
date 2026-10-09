extends Node2D

# Main entry point for Flappy Gary game
# This initializes and controls the overall game flow

func _ready():
	print("Flappy Gary game initialized!")
	
	# Load the main game scene
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")