extends BaseState

func _enter_state():
	super()
	
	Player.velocity.y += Player.jumpVelocity
	
	StateManager._switch_animation("jump")

func _update_state(_delta : float):
	super(_delta)
	
	StateManager._get_input_states()
	StateManager._get_gravity(_delta, Player.jumpGravity)
	StateManager._get_horizontal_movement()
	StateManager._get_flip_h()
	StateManager._get_jump_peak()
	_get_jumpHeight()

func _get_jumpHeight():
	return
