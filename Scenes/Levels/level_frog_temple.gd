extends Node2D

var activated = false
func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton:
		if event.pressed and not event.is_echo():
			if not activated:
				activated = true
				GlobalTime.start = true
				GlobalTime.total_time_in_secs = 0
