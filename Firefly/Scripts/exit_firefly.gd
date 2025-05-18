extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var target = null
@onready var follow_speed := 3.75

func _ready() -> void:
	animation_player.play("UnfollowPlayer")

func _process(delta: float) -> void:
	if target:
		global_position = lerp(global_position, target.firefly_pos.global_position, delta * follow_speed)
