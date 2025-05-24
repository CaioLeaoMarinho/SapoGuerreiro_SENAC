extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var scene_to_go : String = ""

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player: 
		player.in_transition = false

func transition_to(scene : String, transition_type : String):
	scene_to_go = scene
	animation_player.play(transition_type)

func change_scene():
	get_tree().change_scene_to_file(scene_to_go)

func transition_started():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.velocity.x = 0
		player.in_transition = true

func transition_completed():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.in_transition = false
