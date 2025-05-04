extends BaseState

#region Default Base State Methods
func _enter_state():
	super()
	
	StateManager._switch_animation("fall")
	
	Entity.stomp_attack_area.area_entered.connect(_on_stomp_area)
	check_stomp_area()
	
func _update_state(_delta : float):
	
	super(_delta)
	
	StateManager._get_input_direction()
	StateManager._get_gravity(_delta, Entity.fallGravity)
	StateManager._get_horizontal_movement()
	StateManager._get_landing()
	StateManager._get_flip_h()
	StateManager._get_frog_hope(_delta)

func _exit_state():
	Entity.stomp_attack_area.area_entered.disconnect(_on_stomp_area)
#endregion

#region Custom Methods
func _on_stomp_area(area: Area2D):
	if area.is_in_group("hurtbox"):
		stomp_attack(area.owner)
		
func check_stomp_area():
	for area in Entity.stomp_attack_area.get_overlapping_areas():
		_on_stomp_area(area)

func stomp_attack(body):
	body.take_damage(body.life)
	StateManager._switch_state(StateManager.jumpState)
#endregion
