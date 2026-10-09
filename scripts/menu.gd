extends Node2D

# Menu scene controller for Flappy Gary

func _ready():
	print("Menu scene ready!")

func _on_StartButton_pressed():
	# Transition to main game scene
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")