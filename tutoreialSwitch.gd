extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		VitoriaRegeaTransitionScreen.transition_to("res://Scenes/Levels/level_tutorial.tscn", "VitoriaRegea")
