extends Node2D
class_name PipeManager
# Manages spawning and lifecycle of pipe obstacles in Flappy Gary
# This script creates pipe instances at regular intervals and removes them when they go off-screen

@export var spawn_interval = 1.5 # Time between pipe spawns in seconds
@export var pipe_speed = 200.0
@export var pipe_min_height = 100 # Minimum pipe segment height
@export var pipe_max_gap = 200 # Maximum gap between top and bottom pipes
@export var pipe_min_gap = 150 # Minimum gap between top and bottom pipes
@export var base_pipe_length = 80 # Base length of pipe obstacles
@export var max_pipes = 10 # Maximum number of pipe obstacles to keep in game

var pipe_timer = 0.0
var next_spawn_time = 0.0
var active_pipes = [] # Keep track of spawned pipes
var game_over = false # Game over state

func _ready():
	print("Pipe Manager initialized")
	next_spawn_time = pipe_timer + spawn_interval

func _process(_delta):
	# MainGame owns spawning, scoring, and pipe hits.
	pass

func spawn_pipe() -> Node2D:
	var kinds := ["top", "bottom", "both"]
	var pipe = preload("res://scenes/pipe.tscn").instantiate()
	pipe.setup(kinds[randi() % kinds.size()])
	pipe.position = Vector2(860, 0)
	pipe.speed = pipe_speed
	add_child(pipe)
	active_pipes.append(pipe)
	if active_pipes.size() > max_pipes:
		var old_pipe = active_pipes.pop_front()
		if old_pipe.is_inside_tree():
			old_pipe.queue_free()
	return pipe

func cleanup_pipes():
	# Remove all pipe obstacles when game ends or level resets
	for pipe in active_pipes:
		if pipe.is_inside_tree():
			pipe.queue_free()
	active_pipes.clear()

func get_active_pipe_count() -> int:
	return active_pipes.size()

func reset():
	"""Reset pipe manager to initial state"""
	print("Resetting pipe manager")
	cleanup_pipes()
	pipe_timer = 0.0
	next_spawn_time = spawn_interval

func _on_game_over():
	"""Handle game over state"""
	print("Pipe Manager handling game over")
	game_over = true
	cleanup_pipes()
