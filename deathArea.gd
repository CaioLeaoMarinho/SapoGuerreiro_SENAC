extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.state_manager._switch_state(body.state_manager.dieState)
	
