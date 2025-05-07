extends CharacterBody2D

#region Referencias
@onready var sprite2d = $Sprite2D
@onready var collision2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var hurt_animation_player: AnimationPlayer = $HurtAnimationPlayer
@onready var state_manager = $StateMachine
@onready var wall_detector = $WallDetector
@onready var floor_detector: RayCast2D = $FloorDetector
@onready var stomp_hurtbox: Area2D = $StompHurtbox
#endregion

#region Variables
@export var life : int = 2
@export var knockback_force := 300
@export var knockback_duration := 0.1
@export var knockback_invincibility_duration := 0.2
var knockback_invincible := false
var knockback_velocity := Vector2.ZERO
var knockback_timer := 0.0

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
	get_tree().create_timer(knockback_invincibility_duration).timeout.connect(func(): knockback_invincible = false)
	damage_name = damage_type
	
	if not knockback_invincible:
		knockback_invincible = true
		state_manager._switch_state(state_manager.hurtState)
#endregion
