extends Node2D

const exit_firefly = preload("res://Firefly/ExitFirefly.tscn")
const idle_firefly = preload("res://Firefly/IdleFirefly.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var follow_speed := 7.5
@onready var firefly_sprite_2d: Sprite2D = $FireflySprite2D

var target = null

func _ready() -> void:
	var anim_length = animation_player.get_animation("FlyingArround").length
	var random_start = randf_range(0.0, anim_length)
	
	animation_player.play("FlyingArround")
	animation_player.advance(random_start)

func _process(delta: float) -> void:
	if target:
		global_position = lerp(global_position, target.firefly_pos.global_position, delta * follow_speed)

func unfollow(previous_owner):
	var fireflyNode = null
	if previous_owner.is_in_group("player"):
		fireflyNode = exit_firefly.instantiate()
	elif previous_owner.is_in_group("enemy"):
		fireflyNode = idle_firefly.instantiate()
	
	if fireflyNode:
		fireflyNode.global_position = firefly_sprite_2d.global_position
		fireflyNode.target = target
		get_parent().add_child(fireflyNode)
		queue_free()
