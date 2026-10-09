extends Control

func _ready() -> void:
	$StartButton.pressed.connect(_on_start_pressed)
	$SettingsButton.pressed.connect(_on_settings_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_scene.tscn")
