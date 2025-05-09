extends BaseState

func _enter_state():
	var die_type : String
	
	Entity.velocity = Vector2(0, 0)
	Entity.stomp_hurtbox.queue_free()
	Entity.hitbox.queue_free()
	
	if Entity.damage_name == "sword_up_to_down":
		pass
	elif Entity.damage_name == "stomp":
		die_type = "StompDie"
	
	if die_type != null:
		StateManager._switch_animation(die_type)
