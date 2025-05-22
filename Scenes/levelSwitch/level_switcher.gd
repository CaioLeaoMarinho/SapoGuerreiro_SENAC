extends Node2D

@export var nextLevel : String
@export var transition_type : String = "VitoriaRegea"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and nextLevel != null and transition_type != null:
		VitoriaRegeaTransitionScreen.transition_to(nextLevel, transition_type)
