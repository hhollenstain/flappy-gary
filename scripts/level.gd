extends Node

# Level handling for Flappy Gary
class_name LevelManager

var current_level = 1
var score = 0
var difficulty_multiplier = 1.0

func _ready():
	pass

func increment_level():
	current_level += 1
	difficulty_multiplier += 0.2
	return current_level

func get_current_level() -> int:
	return current_level

func update_score(points: int):
	score += points

func get_score() -> int:
	return score

func reset():
	current_level = 1
	score = 0
	difficulty_multiplier = 1.0