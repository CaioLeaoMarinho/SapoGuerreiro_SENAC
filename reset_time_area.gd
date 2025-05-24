extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GlobalTime.total_time_in_secs = 0
