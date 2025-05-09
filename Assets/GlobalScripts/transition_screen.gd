extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var scene_to_go : String = ""

func transition_to(scene : String, transition_type : String):
	scene_to_go = scene
	animation_player.play(transition_type)

func change_scene():
	get_tree().change_scene_to_file(scene_to_go)
