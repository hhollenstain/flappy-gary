extends Node2D

var speed := 200.0

func _process(delta: float) -> void:
	position.x -= speed * delta
	if position.x < -100.0:
		queue_free()
