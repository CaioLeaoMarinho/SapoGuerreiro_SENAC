extends Control

func _ready() -> void:
	visible = false
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("input_pause") and get_tree().paused == false:
		visible = true
		get_tree().paused = true

	elif event.is_action_pressed("input_pause") and get_tree().paused == true:
		visible = false
		get_tree().paused = false

func _on_continuar_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_resetar_pressed() -> void:
	_on_continuar_pressed()
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.state_manager._switch_state(player.state_manager.dieState)
func _on_voltar_menu_pressed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")

func _on_sair_pressed() -> void:
	get_tree().quit()
