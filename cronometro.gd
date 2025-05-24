extends Control

func _ready():
	$Timer.wait_time = 1.0
	$Timer.one_shot = false
	$Timer.autostart = false

func _process(delta):
	if GlobalTime.start and $Timer.is_stopped():
		$Timer.start()
		
	elif not GlobalTime.start and not $Timer.is_stopped():
		$Timer.stop()
		$Label.modulate = Color(255,215,0)

func _on_timer_timeout() -> void:
	GlobalTime.total_time_in_secs += 1
	var m = int(GlobalTime.total_time_in_secs / 60.0)
	var s = GlobalTime.total_time_in_secs - m * 60
	$Label.text = '%02d:%02d' % [m,s]
