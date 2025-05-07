extends BaseState

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _enter_state():
	super()
	if Entity.life <= 0:
		StateManager.die()
	else:
		if player:
			Entity.hurt_animation_player.play("Hurt")
			knockback()
		else:
			StateManager._switch_state(StateManager.walkState)

func _update_state(delta):
	super(delta)
	
	if Entity.knockback_timer > 0.0:
		Entity.velocity = Entity.knockback_velocity
		Entity.knockback_timer -= delta
	else:
		StateManager._get_gravity(delta, 1000)
		
		if Entity.is_on_floor():
			StateManager._switch_state(StateManager.walkState)

func knockback():
	
	var knockback_direction = (Entity.global_position - player.global_position).normalized()
	Entity.knockback_velocity = knockback_direction * Entity.knockback_force

	Entity.knockback_velocity.y = min(Entity.knockback_velocity.y, -50)
	
	Entity.knockback_timer = Entity.knockback_duration
