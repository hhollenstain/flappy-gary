extends SceneTree

func _initialize() -> void:
	_run()

func _run() -> void:
	var failed := false
	if await _menu_opens_settings():
		failed = true
	if await _settings_controls_update():
		failed = true
	if await _game_over_scene_loads():
		failed = true
	if await _playfield_fills_view_and_flap_climbs():
		failed = true
	if await _pipes_leave_room_score_and_hit():
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

func _game_over_scene_loads() -> bool:
	var packed := load("res://scenes/game_over_scene.tscn") as PackedScene
	if packed == null:
		print("FAIL: game over scene failed to load")
		return true
	var game_over := packed.instantiate()
	if not game_over is Control:
		print("FAIL: game over scene root must be a Control")
		game_over.free()
		return true
	root.add_child(game_over)
	await process_frame
	var title := game_over.get_node_or_null("GameOverLabel") as Label
	var restart := game_over.get_node_or_null("RestartButton") as Button
	var score_label := game_over.get_node_or_null("ScoreLabel") as Label
	if title == null or title.text != "Game Over!":
		print("FAIL: game over scene has no Game Over title")
		return true
	if restart == null or restart.text != "Play Again":
		print("FAIL: game over scene has no Play Again button")
		return true
	game_over.high_score = 100
	game_over.set_final_score(12)
	if score_label == null or score_label.text != "Score: 12":
		print("FAIL: game over scene did not show the final score")
		return true
	print("PASS: game over scene loads and shows the score")
	return false

func _playfield_fills_view_and_flap_climbs() -> bool:
	var game := (load("res://scenes/main_scene.tscn") as PackedScene).instantiate()
	root.add_child(game)
	await process_frame
	var camera := game.get_node_or_null("Camera2D") as Camera2D
	var background := game.get_node_or_null("Background") as ColorRect
	var player := game.get_node_or_null("Player") as CharacterBody2D
	if camera == null or background == null or player == null:
		print("FAIL: main scene is missing the camera, background, or player")
		return true
	var view := game.get_viewport().get_visible_rect()
	var background_rect := background.get_global_rect()
	if not background_rect.encloses(view):
		print("FAIL: background does not cover the visible playfield")
		return true
	if camera.position.distance_to(view.get_center()) > 1.0:
		print("FAIL: camera is not centered on the playfield")
		return true
	for _hop in 8:
		var before := player.position.y
		player.jump()
		for _frame in 4:
			await process_frame
		if player.position.y >= before - 4.0:
			print("FAIL: flap no longer climbs after repeated jumps")
			return true
	game.free()
	print("PASS: playfield fills the view and repeated flaps still climb")
	return false

func _pipes_leave_room_score_and_hit() -> bool:
	for child in root.get_children():
		if child is MainGame:
			child.free()
	var packed := load("res://scenes/pipe.tscn") as PackedScene
	for kind in ["top", "bottom", "both"]:
		for _i in 8:
			var sample := packed.instantiate()
			sample.setup(kind)
			if not sample.has_clearance():
				print("FAIL: %s pipe does not keep clearance from the sky and ground" % kind)
				sample.free()
				return true
			sample.free()
	var paired := packed.instantiate()
	paired.position = Vector2(400, 0)
	paired.setup("both", 280.0)
	if paired.segments.size() != 2 or not paired.has_clearance():
		print("FAIL: center passage is missing or too close to the sky or ground")
		paired.free()
		return true
	var gap_rect := Rect2(Vector2(380, 260), Vector2(40, 40))
	var pipe_rect := Rect2(Vector2(380, 20), Vector2(40, 40))
	if paired.hits_rect(gap_rect):
		print("FAIL: the center passage counts as a pipe hit")
		paired.free()
		return true
	if not paired.hits_rect(pipe_rect):
		print("FAIL: overlapping a pipe body does not count as a hit")
		paired.free()
		return true
	paired.free()

	var game := (load("res://scenes/main_scene.tscn") as PackedScene).instantiate()
	root.add_child(game)
	await process_frame
	var player := game.get_node("Player") as CharacterBody2D
	player.position = Vector2(100, 280)
	var scoring_pipe = game.spawn_pipe_of("both", 280.0)
	scoring_pipe.position.x = 40
	game.check_collisions()
	if game.score != 10 or game.get_node("UI/ScoreLabel").text != "Score: 10":
		print("FAIL: passing a pipe did not add to the score")
		return true
	var hitting_pipe = game.spawn_pipe_of("top", 220.0)
	hitting_pipe.position.x = 100
	player.position = Vector2(100, 40)
	ProjectSettings.set_setting("flappy_gary/high_score", 1000)
	game.check_collisions()
	for _frame in 4:
		await process_frame
	var scene := current_scene
	if not game.game_over or scene == null or scene.scene_file_path != "res://scenes/game_over_scene.tscn":
		print("FAIL: hitting a pipe did not end the game")
		return true
	print("PASS: pipes leave a passage, scoring a pass and ending on a hit")
	return false
