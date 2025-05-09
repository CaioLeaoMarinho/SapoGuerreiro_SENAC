extends BaseState

@onready var hitbox: Area2D = $"../../Hitbox"

func _enter_state():
	super()
	
	StateManager._switch_animation("walk")
	
	hitbox.area_entered.connect(_on_hitbox_area)
	check_hitbox_area()
	
func _exit_state():
	if hitbox.area_entered.is_connected(_on_hitbox_area):
		hitbox.area_entered.disconnect(_on_hitbox_area)

func _update_state(_delta : float):
	super(_delta)
	
	StateManager._get_flip_h()
	StateManager._horizontal_movement(_delta)
	_turn()
	
func _turn():
	if Entity.wall_detector.is_colliding() or not Entity.floor_detector.is_colliding():
		Entity.moveDirectionX *= -1
		Entity.wall_detector.scale.x *= -1
		Entity.floor_detector.scale.x *= -1

func _on_hitbox_area(area: Area2D):
	if area.is_in_group("hurtbox") and area.owner.is_in_group("player"):
		cause_damage(area.owner)
		
func check_hitbox_area():
	for area in hitbox.get_overlapping_areas():
		_on_hitbox_area(area)

func cause_damage(body):
	body.take_damage(1, Entity.global_position)
