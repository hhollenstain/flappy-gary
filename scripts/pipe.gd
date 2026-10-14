extends Node2D

# One obstacle column. Layout is either a top pipe, a bottom pipe,
# or both with a gap in the middle. Segment rects are local to this node,
# which is placed at y = 0 so those coordinates match the playfield.
signal player_passed

const WIDTH := 72.0
const GAP := 180.0
const SKY_CLEARANCE := 140.0
const GROUND_Y := 560.0
const GROUND_CLEARANCE := 140.0
const PASSAGE := 80.0

@export var speed := 200.0
var passed := false
var layout := "both"
var segments: Array[Rect2] = []

func setup(kind: String, opening: float = -1.0) -> void:
	layout = kind
	segments.clear()
	for child in get_children():
		child.queue_free()
	match kind:
		"both":
			var center := opening if opening >= 0.0 else randf_range(_gap_center_min(), _gap_center_max())
			var gap_top := center - GAP * 0.5
			var gap_bottom := center + GAP * 0.5
			_add_segment(0.0, gap_top)
			_add_segment(gap_bottom, GROUND_Y)
		"top":
			var end_y := opening if opening >= 0.0 else randf_range(180.0, _top_pipe_max())
			_add_segment(0.0, end_y)
		_:
			layout = "bottom"
			var start_y := opening if opening >= 0.0 else randf_range(_bottom_pipe_min(), 400.0)
			_add_segment(start_y, GROUND_Y)

func has_clearance() -> bool:
	if segments.is_empty():
		return false
	match layout:
		"both":
			if segments.size() != 2:
				return false
			var top := segments[0]
			var bottom := segments[1]
			var gap_top := top.position.y + top.size.y
			var gap_bottom := bottom.position.y
			var gap_height := gap_bottom - gap_top
			return top.position.y <= 1.0 \
				and abs(bottom.position.y + bottom.size.y - GROUND_Y) <= 1.0 \
				and gap_height >= GAP - 0.5 \
				and gap_top >= SKY_CLEARANCE - 0.5 \
				and GROUND_Y - gap_bottom >= GROUND_CLEARANCE - 0.5
		"top":
			var hanging := segments[0]
			var hanging_end := hanging.position.y + hanging.size.y
			return segments.size() == 1 \
				and hanging.position.y <= 1.0 \
				and GROUND_Y - hanging_end >= GROUND_CLEARANCE + PASSAGE - 0.5
		"bottom":
			var standing := segments[0]
			var standing_end := standing.position.y + standing.size.y
			return segments.size() == 1 \
				and abs(standing_end - GROUND_Y) <= 1.0 \
				and standing.position.y >= SKY_CLEARANCE + PASSAGE - 0.5
	return false

func hits_rect(world_rect: Rect2) -> bool:
	for segment in segments:
		var world_segment := Rect2(global_position + segment.position, segment.size)
		if world_segment.intersects(world_rect):
			return true
	return false

func hits_body(body: Node2D) -> bool:
	return hits_rect(_body_rect(body))

func poll_passed(player_x: float) -> bool:
	if passed:
		return false
	if position.x < player_x:
		passed = true
		player_passed.emit()
		return true
	return false

func _process(delta: float) -> void:
	position.x -= speed * delta
	if position.x < -120.0:
		queue_free()

func _add_segment(top_y: float, bottom_y: float) -> void:
	var segment := Rect2(Vector2(-WIDTH * 0.5, top_y), Vector2(WIDTH, bottom_y - top_y))
	segments.append(segment)
	var visual := ColorRect.new()
	visual.offset_left = segment.position.x
	visual.offset_top = segment.position.y
	visual.offset_right = segment.position.x + segment.size.x
	visual.offset_bottom = segment.position.y + segment.size.y
	visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visual.color = Color(0.12, 0.62, 0.18, 1)
	add_child(visual)

func _body_rect(body: Node2D) -> Rect2:
	var shape_node := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape_node != null and shape_node.shape is RectangleShape2D:
		var shape := shape_node.shape as RectangleShape2D
		var extents := shape.size * 0.5 * shape_node.global_scale
		var center := shape_node.global_position
		return Rect2(center - extents, extents * 2.0)
	return Rect2(body.global_position - Vector2(20, 20), Vector2(40, 40))

func _gap_center_min() -> float:
	return SKY_CLEARANCE + GAP * 0.5

func _gap_center_max() -> float:
	return GROUND_Y - GROUND_CLEARANCE - GAP * 0.5

func _top_pipe_max() -> float:
	return GROUND_Y - GROUND_CLEARANCE - PASSAGE

func _bottom_pipe_min() -> float:
	return SKY_CLEARANCE + PASSAGE
