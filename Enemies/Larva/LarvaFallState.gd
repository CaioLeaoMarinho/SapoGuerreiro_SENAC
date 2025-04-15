extends BaseState

func _update_state(_delta : float):
	super(_delta)
	
	StateManager._get_gravity(_delta, Entity.fallGravity)
	StateManager._get_landing()
