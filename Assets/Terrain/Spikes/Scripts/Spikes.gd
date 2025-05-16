extends Sprite2D

@onready var hitbox: Area2D = $Hitbox
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D
@export var knockback_force : Vector2 = Vector2(0, -400)
func _ready() -> void:
	collision_shape_2d.shape.size = get_rect().size
	
func _process(_delta: float) -> void:
	for area in hitbox.get_overlapping_areas():
		if area.owner.is_in_group("player"):
			area.owner.take_damage(area.owner.life, knockback_force, global_position)
