extends Node2D

# Signal emitted when a pipe is created
signal pipe_created(pipe)
# Signal emitted when a pipe should be scored (passed by player)
signal pipe_scored(pipe)
# Signal emitted when a pipe is removed
signal pipe_removed(pipe)

@export var pipe_scene: PackedScene
@export var spawn_interval := 1.5
@export var pipe_speed := 200.0
@export var min_pipe_gap := 150.0
@export var max_pipe_gap := 250.0
@export var bottom_limit := 500.0
@export var top_limit := 100.0

var pipes := []
var spawn_timer := 0.0
var active_pipes := []

func _ready():
	print("PipeManager ready!")
	queue_redraw()

func start():
	spawn_timer = spawn_interval
	for pipe in pipes:
		if pipe.is_inside_tree():
			pipe.queue_free()
	pipes.clear()
	active_pipes.clear()

func update(delta):
	spawn_timer += delta
	
	if spawn_timer >= spawn_interval:
		spawn_pipe()
		spawn_timer = 0.0
	
	var to_remove := []
	for pipe in active_pipes:
		if pipe and pipe.is_inside_tree():
			pipe.update(delta)
			if pipe.should_remove():
				to_remove.append(pipe)
	
	for pipe in to_remove:
		active_pipes.erase(pipe)
		if pipe.is_inside_tree():
			pipe.queue_free()
			emit_signal("pipe_removed", pipe)

func spawn_pipe():
	var pipe := pipe_scene.instantiate()
	pipe.position = Vector2(900, randf_range(min_pipe_gap, bottom_limit - min_pipe_gap))
	add_child(pipe, true)
	active_pipes.append(pipe)
	pipe_created.emit(pipe)

func cleanup():
	for pipe in active_pipes:
		if pipe and pipe.is_inside_tree():
			pipe.queue_free()
	active_pipes.clear()
	for pipe in pipes:
		if pipe and pipe.is_inside_tree():
			pipe.queue_free()
	pipes.clear()

func _process(delta):
	update(delta)
