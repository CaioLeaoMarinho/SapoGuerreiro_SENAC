extends BaseState

func _enter_state():
	_get_start_position()

func _get_start_position():
	if Entity.current_frog_rope:
		var left_marker = Entity.current_frog_rope.owner.get_node("PositionLeft")
		var right_marker = Entity.current_frog_rope.owner.get_node("PositionRight")

		var dist_left = Entity.global_position.distance_to(left_marker.global_position)
		var dist_right = Entity.global_position.distance_to(right_marker.global_position)

		var start_pos: Vector2
		var end_pos: Vector2

		if dist_left < dist_right:
			start_pos = left_marker.global_position
			end_pos = right_marker.global_position
		else:
			start_pos = right_marker.global_position
			end_pos = left_marker.global_position

		Entity.global_position = start_pos
