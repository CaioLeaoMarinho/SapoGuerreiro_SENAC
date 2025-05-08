extends CharacterBody2D

#region Referencias
@onready var sprite2d = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var collision2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var hurt_animation_player: AnimationPlayer = $HurtAnimationPlayer
@onready var state_manager = $StateMachine
@onready var wall_detector = $WallDetector
@onready var floor_detector: RayCast2D = $FloorDetector
@onready var stomp_hurtbox: Area2D = $StompHurtbox
@onready var invencibility_timer: Timer = $InvencibilityTimer
#endregion

#region Variables
@export var life : int = 2
@export var damage : int = 1
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
	if not knockback_invincible:
		knockback_invincible = true
		invencibility_timer.start()
		life -= damage
		damage_name = damage_type
		state_manager._switch_state(state_manager.hurtState)
#endregion


func _on_invencibility_timer_timeout() -> void:
	if knockback_invincible:
		knockback_invincible = false
