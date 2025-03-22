extends BaseState


func _enter_state():
	super()
	
	StateManager._switch_state(StateManager.fallState)
