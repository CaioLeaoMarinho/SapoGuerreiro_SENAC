extends BaseState

func _enter_state():
	owner.queue_free()
