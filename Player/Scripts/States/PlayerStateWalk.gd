extends BaseState

func _enter_state():
	super()
	
	StateManager._switch_animation("walk")

func _update_state(delta : float):
	super(delta)
	
	StateManager._get_falling()
	StateManager._get_jump()
	StateManager._get_horizontal_movement()
	StateManager._get_flip_h()
	StateManager._get_idle()
