extends BaseState


func _enter_state():
	super()
	
	StateManager._switch_animation("fall")

func _update_state(_delta : float):
	super(_delta)
	
	StateManager._switch_state(StateManager.fallState)
