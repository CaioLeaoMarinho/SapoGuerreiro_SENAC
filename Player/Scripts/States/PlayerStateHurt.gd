extends BaseState

func _enter_state():
	super()
	if Entity.life <= 0:
		StateManager.die()
	else:
		Entity.hurt_animation_player.play("Hurt")
		knockback()
		
func _update_state(delta):
	super(delta)
	
	if Entity.knockback_timer > 0.0:
		Entity.velocity = Entity.knockback_velocity
		Entity.knockback_timer -= delta
	else:
		StateManager._get_gravity(delta, 750)
		
		StateManager._get_landing()

func knockback():
	var knockback_direction = (Entity.global_position - Entity.agressor_pos).normalized()
	Entity.knockback_velocity = knockback_direction * Entity.knockback_force

	Entity.knockback_velocity.y = min(Entity.knockback_velocity.y, -50)

	Entity.knockback_timer = Entity.knockback_duration
