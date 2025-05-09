extends BaseState

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _enter_state():
	super()
	if Entity.life <= 0:
		StateManager.die()
	else:
		if player:
			Entity.hurt_animation_player.play("Hurt")
		else:
			StateManager._switch_state(StateManager.walkState)
