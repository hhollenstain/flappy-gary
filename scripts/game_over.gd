extends Control

@export var score = 0
@export var high_score = 0

func _ready() -> void:
	$RestartButton.pressed.connect(_on_restart_pressed)
	$MenuButton.pressed.connect(_on_menu_pressed)
	
	# Load high score from project settings or initialize to 0
	high_score = ProjectSettings.get_setting("flappy_gary/high_score", 0)
	$HighScoreLabel.text = "High Score: " + str(high_score)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scene.tscn")
	
func set_final_score(final_score: int) -> void:
	score = final_score
	$ScoreLabel.text = "Score: " + str(score)
	
	# Update high score if this is a new record
	if score > high_score:
		high_score = score
		ProjectSettings.set_setting("flappy_gary/high_score", high_score)
		ProjectSettings.save()
		$HighScoreLabel.text = "High Score: " + str(high_score)