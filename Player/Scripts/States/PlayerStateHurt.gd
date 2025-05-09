extends BaseState

var tween : Tween = null

func _enter_state():
	super()
	if Entity.life <= 0:
		StateManager.die()
	else:
		Entity.hurt_animation_player.play("Hurt")
		
		if Entity.global_position.x < Entity.agressor_pos.x:
			if Entity.victim_knockback_force.x > 0:
				Entity.victim_knockback_force.x *= -1
			
		knockback()
		
func _update_state(delta):
	super(delta)
	
	if Entity.knockback_vector != Vector2.ZERO:
		Entity.velocity = Entity.knockback_vector
		
func _exit_state():
	super()
	
	if tween:
		tween.kill()
		tween = null
		Entity.knockback_vector = Vector2.ZERO

func knockback(knockback_force : Vector2 = Entity.victim_knockback_force, duration : float = Entity.knockback_duration):
	if knockback_force != Vector2.ZERO:
		if tween:
			tween.kill()
			
		Entity.in_inertia = true
			
		Entity.knockback_vector = knockback_force
		
		tween = get_tree().create_tween()
		
		tween.parallel().tween_property(Entity, 'knockback_vector', Vector2.ZERO, duration)
		tween.finished.connect(_on_knockback_finished)
		
func _on_knockback_finished():
	StateManager._switch_state(StateManager.idleState)
