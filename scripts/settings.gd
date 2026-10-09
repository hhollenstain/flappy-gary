extends Control

var volume := 1.0
var difficulty := "medium"
var difficulties: Array[String] = ["easy", "medium", "hard"]

func _ready() -> void:
	$VolumeSlider.value = volume
	_show_difficulty()
	$VolumeSlider.value_changed.connect(_on_volume_changed)
	$DifficultyButton.pressed.connect(_on_difficulty_pressed)
	$BackButton.pressed.connect(_on_back_pressed)

func _on_volume_changed(value: float) -> void:
	volume = value

func _on_difficulty_pressed() -> void:
	var index := difficulties.find(difficulty)
	difficulty = difficulties[(index + 1) % difficulties.size()]
	_show_difficulty()

func _show_difficulty() -> void:
	$DifficultyLabel.text = "Difficulty: " + difficulty

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scene.tscn")
