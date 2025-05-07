extends BaseState

func _enter_state():
	super()
	
	StateManager._switch_animation("walk")

func _update_state(_delta : float):
	super(_delta)
	
	StateManager._get_flip_h()
	StateManager._horizontal_movement(_delta)
	_turn()
	
	
func _turn():
	if Entity.wall_detector.is_colliding() or not Entity.floor_detector.is_colliding():
		Entity.moveDirectionX *= -1
		Entity.wall_detector.scale.x *= -1
		Entity.floor_detector.scale.x *= -1
