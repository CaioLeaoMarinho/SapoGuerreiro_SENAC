extends BaseState

func _enter_state():
	super()
	
	StateManager._switch_animation("fall")
	
func _update_state(_delta : float):
	
	super(_delta)
	
	StateManager._get_input_direction()
	StateManager._get_gravity(_delta, Entity.fallGravity)
	StateManager._get_horizontal_movement()
	StateManager._get_landing()
	StateManager._get_flip_h()
	StateManager._get_frog_hope(_delta)
