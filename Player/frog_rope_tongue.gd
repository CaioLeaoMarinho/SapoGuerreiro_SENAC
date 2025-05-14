extends Node2D

@onready var tongue_sprite: Sprite2D = $Sprite2D
var tile_size = 8

func _set_rope(start_pos, end_pos):
	var distance = start_pos.distance_to(end_pos)
	
	global_position = end_pos
	_update_rotation(start_pos)
	
	look_at(start_pos)
	
	rotation_degrees += 90
	
	for i in int (distance / tile_size) + 1:
		var newRopeTile = tongue_sprite.duplicate()
		add_child(newRopeTile)
		newRopeTile.position = Vector2(0, -(i * 8))

func _update_rotation(target_pos : Vector2):
	look_at(target_pos)
	rotation_degrees += 90
