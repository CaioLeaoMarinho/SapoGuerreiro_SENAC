extends BaseState

func _enter_state():
	Entity.velocity = Vector2.ZERO
	VitoriaRegeaTransitionScreen.transition_to(Entity.get_tree().current_scene.scene_file_path, "VitoriaRegea")
