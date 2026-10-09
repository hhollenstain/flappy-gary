extends SceneTree

func _initialize() -> void:
	_run()

func _run() -> void:
	var failed := false
	if await _menu_opens_settings():
		failed = true
	if await _settings_controls_update():
		failed = true
	if failed:
		print("GODOT TESTS FAILED")
		quit(1)
		return
	print("GODOT TESTS PASSED")
	quit(0)

func _menu_opens_settings() -> bool:
	var menu := (load("res://scenes/menu_scene.tscn") as PackedScene).instantiate()
	root.add_child(menu)
	await process_frame
	var button := menu.get_node_or_null("SettingsButton") as Button
	if button == null or button.text != "Settings":
		print("FAIL: SettingsButton is missing from the menu")
		return true
	if button.size.x < 20.0 or button.size.y < 20.0:
		print("FAIL: SettingsButton has no visible size")
		return true
	button.pressed.emit()
	for _i in 8:
		await process_frame
	var scene := current_scene
	if scene == null or scene.scene_file_path != "res://scenes/settings_scene.tscn":
		print("FAIL: SettingsButton did not display the settings scene")
		return true
	var title := scene.get_node_or_null("SettingsTitle") as Label
	if title == null or title.text != "Settings":
		print("FAIL: settings scene has no Settings title")
		return true
	print("PASS: SettingsButton opens the settings scene")
	return false

func _settings_controls_update() -> bool:
	var settings := (load("res://scenes/settings_scene.tscn") as PackedScene).instantiate()
	root.add_child(settings)
	await process_frame
	var slider := settings.get_node_or_null("VolumeSlider") as HSlider
	var difficulty_button := settings.get_node_or_null("DifficultyButton") as Button
	var label := settings.get_node_or_null("DifficultyLabel") as Label
	if slider == null or difficulty_button == null or label == null:
		print("FAIL: settings scene is missing volume or difficulty controls")
		return true
	slider.value = 0.4
	if not is_equal_approx(settings.volume, 0.4):
		print("FAIL: volume slider did not update the setting")
		return true
	difficulty_button.pressed.emit()
	if settings.difficulty != "hard" or label.text != "Difficulty: hard":
		print("FAIL: difficulty button did not update the label")
		return true
	print("PASS: settings volume and difficulty controls update")
	return false
