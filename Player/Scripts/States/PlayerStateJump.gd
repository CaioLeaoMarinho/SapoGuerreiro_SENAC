extends BaseState

func _enter_state():
	super()
	
	_calculate_jump_velocity(Entity.jumpHeight)
	Entity.velocity.y += Entity.jumpVelocity
	
	StateManager._switch_animation("jump")

func _update_state(_delta : float):
	super(_delta)
	
	StateManager._get_input_states()
	StateManager._get_gravity(_delta, Entity.jumpGravity)
	StateManager._get_horizontal_movement()
	StateManager._get_flip_h()
	StateManager._get_jump_peak()
	
	_get_jumpHeight()

func _get_jumpHeight():
	return

func _calculate_jump_velocity(jumpHeight: float):
	Entity.jumpGravity = 2 * Entity.jumpHeight / pow(Entity.jumpTimeToPeak, 2)
	Entity.jumpVelocity = -sqrt(2 * Entity.jumpGravity * Entity.jumpHeight)
