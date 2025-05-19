extends CharacterBody2D

#region Referencias
@onready var sprite2d = $Sprite2D
@onready var state_manager = $StateMachine
@onready var hitbox : Area2D = $Hitbox
@onready var collision2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var hurt_animation_player: AnimationPlayer = $HurtAnimationPlayer
@onready var wall_detector = $WallDetector
@onready var floor_detector: RayCast2D = $FloorDetector
@onready var stomp_hurtbox: Area2D = $StompHurtbox
@onready var firefly_pos: Marker2D = $FireflyPos
const firefly = preload("res://Firefly/FollowingFirefly.tscn")
#endregion

#region Variables
@export var life : int = 1
@export var damage : int = 1
@export var have_firefly : bool = false
@export var knockback_force : Vector2 = Vector2(1000, -500)

@export var currentMoveSpeed = 5000
var moveDirectionX = -1

var canSwitchState = true
var damage_name : String
var fireflies_list : Array = []
#endregion

#region Default Methods
func _ready():
	_initilialize_larva_components()
	
func _physics_process(_delta):
	move_and_slide()
#endregion

#region Custom Methods

func _initilialize_larva_components():
	if have_firefly:
		for i in range(life):
			var fireflyNode = firefly.instantiate()
			fireflyNode.global_position = firefly_pos.global_position
			get_parent().add_child.call_deferred(fireflyNode)
			fireflyNode.target = self
			fireflies_list.append(fireflyNode)
	
func take_damage(agressor_damage : int, damage_type : String):
	life -= agressor_damage
	damage_name = damage_type
	state_manager._switch_state(state_manager.hurtState)
#endregion
