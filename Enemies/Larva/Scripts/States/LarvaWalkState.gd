extends BaseState

func _enter_state():
	super()
	
	StateManager._switch_animation("walk")

func _update_state(_delta : float):
	super(_delta)
	
	StateManager._get_flip_h()
	StateManager._horizontal_movement(_delta)
	_wall_turn()
	
func _wall_turn():
	if(Entity.wall_detector.is_colliding()):
		Entity.moveDirectionX *= -1
		Entity.wall_detector.scale.x *= -1
