extends BaseState

func _enter_state():
	if Entity.life <= 0:
		StateManager._switch_state(StateManager.dieState)
	else:
		pass
