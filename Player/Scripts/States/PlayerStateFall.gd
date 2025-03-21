extends BaseState

func _enter_state():
	super()
	
	StateManager._switch_animation("fall")
	
func _update_state(delta : float):
	
	super(delta)
	
	StateManager._get_gravity(delta)
	StateManager._get_horizontal_movement()
	StateManager._get_landing()
	StateManager._get_flip_h()
