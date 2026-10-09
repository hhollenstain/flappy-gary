extends Node2D

# Game over scene controller for Flappy Gary

var current_score: int = 0

func _ready():
	print("Game over screen ready!")
	update_score()

func update_score():
	# Update the score display
	$ScoreLabel.text = "Score: " + str(current_score)

func _on_RestartButton_pressed():
	# Return to main game scene
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_MenuButton_pressed():
	# Return to main menu scene (if we had one)
	get_tree().change_scene_to_file("res://scenes/menu_scene.tscn")