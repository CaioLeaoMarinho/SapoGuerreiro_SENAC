extends BaseState

@onready var camera_2d: Camera2D = $"../../Camera2D"
@onready var press_any_button_label: Label = $"../../HUDLayer/Panel/PressAnyButtonLabel"
@onready var press_any_button_animation_player: AnimationPlayer = $"../../HUDLayer/Panel/PressAnyButtonLabel/AnimationPlayer"

func _enter_state():
	press_any_button_label.visible = true
	press_any_button_animation_player.play("FadeInFadeOut")

func _exit_state():
	press_any_button_animation_player.stop()

func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton:
		if event.pressed and not event.is_echo():
			press_any_button_label.visible = false
			start_to_menu()
	
func start_to_menu():
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(camera_2d, "global_position", Vector2(772, 435), 0.75)
	tween.finished.connect(_on_animation_finished)

func _on_animation_finished():
	StateManager._switch_state(StateManager.main_menuState)
