extends Node2D

@export var life_increase := 1
@onready var firefly_sprite_2d: Sprite2D = $FireflySprite2D
@onready var collect_range: Sprite2D = $CollectRange
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var entity_detector: Area2D = $EntityDetector

func _ready() -> void:
	animation_player.play("FlyingArround")

func collect():
	animation_player.play("Collected")
