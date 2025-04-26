extends BaseState

# Configurações do Swing
var swing_angle: float = 0.0
var target_angle: float = 0.0
const target_speed: float = 1250.0
var rope_length: float = 0.0
var is_hooked: bool = false
var swing_direction: int = 1

var origin_pos: Vector2
var start_pos: Vector2
var end_pos: Vector2

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

# Define os pontos de início e fim do swing
func _get_markers_position():
	if Entity.current_frog_rope:
		var left_marker = Entity.current_frog_rope.owner.get_node("PositionLeft")
		var right_marker = Entity.current_frog_rope.owner.get_node("PositionRight")

		var dist_left = Entity.global_position.distance_to(left_marker.global_position)
		var dist_right = Entity.global_position.distance_to(right_marker.global_position)

		if dist_left > dist_right:
			end_pos = left_marker.global_position
			swing_direction = 1
		else:
			end_pos = right_marker.global_position
			swing_direction = -1
		start_pos = Entity.global_position

# Inicia o swing
func _attach_rope():
	is_hooked = true

	swing_angle = (start_pos - origin_pos).angle()

	target_angle = (end_pos - origin_pos).angle()

# Movimento suave em arco
func _swing_movement(delta):
	var angular_speed = target_speed / rope_length
# Movimento com velocidade angular constante
	var angle_change = angular_speed * delta * swing_direction
	var remaining_angle = abs(target_angle - swing_angle)
	
	# Evita overshooting
	if abs(angle_change) > remaining_angle:
		angle_change = sign(angle_change) * remaining_angle
	
	swing_angle += angle_change
	
	# Atualiza posição
	var new_position = origin_pos + Vector2(cos(swing_angle), sin(swing_angle)) * rope_length
	Entity.global_position = new_position

func _detach_rope():
	is_hooked = false
	Entity.launched_by_rope = true
	
	var tangent_vector = Vector2(-sin(swing_angle), cos(swing_angle))
	Entity.velocity = tangent_vector * target_speed * swing_direction
	
	StateManager._switch_state(StateManager.idleState)

func _get_detach_rope():
	if Input.is_action_just_pressed("input_jump"):
		_detach_rope()

	if abs(swing_angle - target_angle) < 0.6:
		_detach_rope()
#endregion
