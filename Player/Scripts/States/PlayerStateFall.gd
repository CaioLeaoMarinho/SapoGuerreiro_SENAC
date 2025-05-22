extends BaseState

#region Default Base State Methods
func _enter_state():
	super()
	
	if not Entity.launched_by_rope:
		StateManager._switch_animation("fall")
	else:
		StateManager._switch_animation("fallFrogRope")
	
	Entity.stomp_attack_area.area_entered.connect(_on_stomp_area)
	
func _update_state(_delta : float):
	
	super(_delta)
	
	StateManager._get_input_direction()
	StateManager._get_gravity(_delta, Entity.fallGravity)
	StateManager._get_horizontal_movement()
	StateManager._get_landing()
	StateManager._get_flip_h()
	StateManager._get_frog_hope(_delta)
	StateManager._get_jump()
	StateManager._get_jump_buffer()

func _exit_state():
	Entity.stomp_attack_area.area_entered.disconnect(_on_stomp_area)
#endregion

#region Custom Methods
func _on_stomp_area(area: Area2D):
	if area.is_in_group("stomp_hurtbox"): 
		if Entity.stomp_attack_area.global_position.y < area.global_position.y:
			stomp_attack(area.owner)

func stomp_attack(body):
	body.take_damage(1, "stomp")
	Entity.velocity.y = Entity.stomp_jump_height * -1
	StateManager._switch_state(StateManager.jumpState)
#endregion
