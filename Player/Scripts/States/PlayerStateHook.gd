extends BaseState

#region Variables
var swing_angle = 0.0
var swing_angular_velocity = 0.0
var max_swing_angle = 60 # graus
var swing_direction = 0
var rope_length = 0.0

var is_hooked = false

var origin_pos: Vector2
var start_pos: Vector2
var end_pos: Vector2

var target_swing_angle = 0.0
#endregion

#region Default Methods
func _enter_state():
	super()
	
	origin_pos = Entity.current_frog_rope.global_position
	
	_get_markers_position()
	
	rope_length = origin_pos.distance_to(start_pos)
	
	_attach_rope()

func _update_state(_delta : float):
	super(_delta)
	
	if is_hooked:
		_get_detach_rope()
		_swing_moviment(_delta)
#endregion

#region Custom Methods
func _get_markers_position():
	if Entity.current_frog_rope:
		var left_marker = Entity.current_frog_rope.owner.get_node("PositionLeft")
		var right_marker = Entity.current_frog_rope.owner.get_node("PositionRight")

		var dist_left = Entity.global_position.distance_to(left_marker.global_position)
		var dist_right = Entity.global_position.distance_to(right_marker.global_position)

		if dist_left < dist_right:
			end_pos = right_marker.global_position
		else:
			end_pos = left_marker.global_position
			
		start_pos = Entity.global_position

func _attach_rope():
	var direction_vector = (start_pos - origin_pos).normalized()
	
	target_swing_angle = origin_pos.angle_to_point(end_pos)
	
	swing_angle = atan2(direction_vector.x, direction_vector.y)
	swing_direction = sign(start_pos.x - origin_pos.x) * -1
	
	is_hooked = true

func _detach_rope():
	is_hooked = false
	
	var tangent = Vector2(cos(swing_angle), -sin(swing_angle))
	Entity.velocity = tangent.normalized() * swing_angular_velocity * rope_length
	
	StateManager._switch_state(StateManager.idleState)

func _get_detach_rope():
	if Input.is_action_just_pressed("input_jump"):
		_detach_rope()

	if abs(origin_pos.angle_to_point(Entity.global_position) - target_swing_angle) < 0.2:
		_detach_rope()

func _swing_moviment(delta):
	# Calcula aceleração angular
	var angular_acceleration = -(2000 / rope_length) * sin(swing_angle)
	
	# Atualiza velocidade e ângulo
	swing_angular_velocity += angular_acceleration * delta
	swing_angle += swing_angular_velocity * delta
	
	# Atualiza posição com base no ângulo atual
	var offset = Vector2(sin(swing_angle), cos(swing_angle)) * rope_length
		
	Entity.global_position = origin_pos + offset
#endregion
