extends CharacterBody2D

#region Referencias
@onready var sprite2d = $Sprite2D
@onready var hitbox : Area2D = $Hitbox
@onready var collision2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var hurt_animation_player: AnimationPlayer = $HurtAnimationPlayer
@onready var state_manager = $StateMachine
@onready var wall_detector = $WallDetector
@onready var floor_detector: RayCast2D = $FloorDetector
@onready var stomp_hurtbox: Area2D = $StompHurtbox
#endregion

#region Variables
@export var life : int = 1
@export var damage : int = 1

var currentMoveSpeed = 3000
var moveDirectionX = -1

var canSwitchState = true
var damage_name : String
#endregion

#region Default Methods
func _ready():
	_initilialize_larva_components()
	
func _physics_process(_delta):
	move_and_slide()
#endregion

#region Custom Methods

func _initilialize_larva_components():
	pass
	
func take_damage(damage : int, damage_type : String):
	life -= damage
	damage_name = damage_type
	state_manager._switch_state(state_manager.hurtState)
#endregion
