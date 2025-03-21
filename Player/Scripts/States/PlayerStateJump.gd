extends BaseState


func _enter_state():
	super()
	
	Player.velocity.y = Player.jumpVelocity
	
	StateManager._switch_animation("jump")

func _update_state(delta : float):
	super(delta)
	
	StateManager._get_gravity(delta)
	StateManager._get_horizontal_movement()
	StateManager._get_flip_h()
	StateManager._get_jump_peak()
