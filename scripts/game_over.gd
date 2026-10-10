extends Control

var score = 0

func _ready() -> void:
	$RestartButton.pressed.connect(_on_restart_pressed)
	$MenuButton.pressed.connect(_on_menu_pressed)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scene.tscn")
	
func set_final_score(final_score: int) -> void:
	score = final_score
	$ScoreLabel.text = "Score: " + str(score)