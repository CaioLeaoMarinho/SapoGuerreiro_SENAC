extends Sprite2D

var player_inside = false
var can_hook = true

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_inside = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_inside = false
		can_hook = true 
