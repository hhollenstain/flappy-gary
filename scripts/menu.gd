extends Node2D

# Menu scene controller for Flappy Gary

func _ready():
	print("Menu scene ready!")

func _on_StartButton_pressed():
	# Transition to main game scene
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_SettingsButton_pressed():
	# Transition to settings scene
	get_tree().change_scene_to_file("res://scenes/settings_scene.tscn")