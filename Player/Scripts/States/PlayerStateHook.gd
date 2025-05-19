extends BaseState

#region Variables
var current_swing_angle: float = 0.0
var target_angle: float = 0.0
var rope_length: float = 0.0
var is_hooked: bool = false
var swing_direction: int = 1

var origin_pos: Vector2
var start_pos: Vector2
var end_pos: Vector2
#endregion

#region Default State Methods
func _enter_state():
	super()
	origin_pos = Entity.current_frog_rope.global_position
	_get_markers_position()
	rope_length = origin_pos.distance_to(start_pos)
	_attach_rope()

func _update_state(delta: float):
	super(delta)
	if is_hooked:
		_get_detach_rope()
		_swing_movement(delta)
		_update_rotation()
		get_tree().get_first_node_in_group("tongue_rope")._update_rotation(Entity.mouth_marker_2d.global_position)

func _exit_state():
	super()
	get_tree().get_first_node_in_group("tongue_rope").queue_free()
#endregion

#region Custom Methods
func _get_markers_position():
	if Entity.current_frog_rope:
		var hook_anchor = Entity.current_frog_rope.owner
		var left_marker = hook_anchor.get_node("PositionLeft")
		var right_marker = hook_anchor.get_node("PositionRight")

		if Entity.global_position.x < origin_pos.x:
			end_pos = right_marker.global_position
			swing_direction = -1
		else:
			end_pos = left_marker.global_position
			swing_direction = 1

		start_pos = Entity.global_position

func _attach_rope():
	is_hooked = true
	Entity.current_frog_rope.owner.double_clicker_timer.start()
	var ropeNode = Entity.tongue_rope.instantiate()
	get_parent().add_child(ropeNode)
	ropeNode._set_rope(start_pos, origin_pos)
	
	current_swing_angle = (start_pos - origin_pos).angle()

	target_angle = (end_pos - origin_pos).angle()
	
	Entity.facing = swing_direction * -1
	StateManager._get_flip_h()
	
	if Entity.facing > 0:
		StateManager._switch_animation("frogRope_D")
	else:
		StateManager._switch_animation("frogRope_E")

func _swing_movement(delta):
	var angular_speed = Entity.target_rope_speed / rope_length
	var angle_change = angular_speed * delta * swing_direction
	var remaining_angle = abs(target_angle - current_swing_angle)
	
	if abs(angle_change) > remaining_angle:
		angle_change = sign(angle_change) * remaining_angle
	
	current_swing_angle += angle_change
	
	var new_position = origin_pos + Vector2(cos(current_swing_angle), sin(current_swing_angle)) * rope_length
	Entity.global_position = new_position

func _detach_rope():
	is_hooked = false
	Entity.launched_by_rope = true
	get_tree().get_first_node_in_group("tongue_rope").queue_free()
	
	var tangent_vector = Vector2(-sin(current_swing_angle), cos(current_swing_angle))
	Entity.velocity = tangent_vector * Entity.target_rope_speed * swing_direction
	
	StateManager._switch_state(StateManager.idleState)

func _get_detach_rope():
	if Input.is_action_just_pressed("input_jump") and Entity.current_frog_rope.owner.double_clicker_timer.time_left <= 0:
		_detach_rope()

	if abs(current_swing_angle - target_angle) < 0.6:
		_detach_rope()

func _update_rotation():
	Entity.look_at(Entity.current_frog_rope.global_position)
#endregion
