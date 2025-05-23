extends CharacterBody2D

#region References
@onready var sprite2d: Sprite2D = $Sprite2D
@onready var collision2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var states_animation_player: AnimationPlayer = $StatesAnimationPlayer
@onready var hurt_animation_player: AnimationPlayer = $HurtAnimationPlayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var state_manager = $StateMachine
@onready var frog_rope_detector: Area2D = $FrogRopeDetector
@onready var stomp_attack_area: Area2D = $StompAttackArea
@onready var invencibility_timer: Timer = $InvencibilityTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer
@onready var mouth_marker_2d: Marker2D = $MouthPos
@onready var firefly_pos: Marker2D = $FireflyPos

const tongue_rope = preload("res://Player/FrogRopeTongue.tscn")
const firefly = preload("res://Firefly/FollowingFirefly.tscn")
#endregion

#region Variables
@export_category("Configurar Player")
@export var life : int = 2
var hurt_invencible : bool = false
var knockback_vector := Vector2.ZERO
@export var knockback_duration : float = 0.25
var victim_knockback_force : Vector2 = Vector2.ZERO
@export_category("Configurar movimento")
@export var maxMoveSpeed = 700
var currentMoveSpeed = maxMoveSpeed

@export_category("Configurar Acelerações")
@export var instantAcceleration = 100
@export var instantDeceleration = 100
@export var inertiaAcceleration = 10
@export var inertiaDeceleration = 10
var acceleration = 0
var deceleration = 0

var moveDirectionX = 0

var jumpGravity = 0
@export_category("Gravidade de queda")
@export var fallGravity = 2000
var jumpVelocity = 0
@export_category("Configurar pulo")
@export var jumpHeight = 200
@export var stomp_jump_height = 1000
@export var jumpTimeToPeak = 0.5
@export var maxJumps = 1
var currentJumps = 0
@export var jumpHeightMult = 0.5
@export_category("Configurar frog rope")
@export var min_rope_distance = 150
@export var max_rope_distance = 1000
@export var target_rope_speed: float = 1000.0
@export var rope_buffer_time: float = 0.1

var rope_buffered = false
var rope_buffer_timer = 0.0

var facing = 1

var canSwitchState = true
var in_transition : bool = true

var can_hook = true
var current_frog_rope: Node = null
var last_frog_rope: Node = null
var in_inertia = false
var launched_by_rope = false
var agressor_pos : Vector2

var fireflies_list : Array = []
#endregion

#region Default Methods
func _ready():
	_initilialize_player_components()
	
func _physics_process(_delta):
	move_and_slide()
	update_acceleration()
#endregion

#region Custom Methods

func _initilialize_player_components():
	for i in range(life):
		var fireflyNode = firefly.instantiate()
		fireflyNode.global_position = firefly_pos.global_position
		get_parent().add_child.call_deferred(fireflyNode)
		fireflyNode.target = self
		fireflies_list.append(fireflyNode)
		
	sprite2d.get_material().set_shader_parameter("hit_effect", false)
	
func get_valid_frog_ropes() -> Array:
	var valid_ropes = []
	var overlapping_areas = frog_rope_detector.get_overlapping_areas()
	
	for frog_rope in get_tree().get_nodes_in_group("frog_rope"):
		if frog_rope in overlapping_areas:
			var distance = global_position.distance_to(frog_rope.global_position)
			if distance <= max_rope_distance:
				valid_ropes.append(frog_rope)
	
	return valid_ropes
	
func get_closest_frog_rope() -> Node:
	var closest_rope = null
	var closest_distance = max_rope_distance
	var valid_ropes = get_valid_frog_ropes()

	for frog_rope in valid_ropes:
		var distance = global_position.distance_to(frog_rope.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_rope = frog_rope

	return closest_rope

func update_acceleration():
	if not in_inertia and not launched_by_rope or is_on_floor():
		acceleration = instantAcceleration
		deceleration = instantDeceleration
	else:
		acceleration = inertiaAcceleration
		deceleration = inertiaDeceleration

func update_rotation():
	if state_manager.currentState != state_manager.hookState:
		rotation = 0
		
func take_damage(damage : int, agressor_force : Vector2, agressor_position : Vector2):
	if not hurt_invencible:
		hurt_invencible = true
		life -= damage
		
		invencibility_timer.start()
		victim_knockback_force = agressor_force
		agressor_pos = agressor_position
		
		for i in range(min(damage, fireflies_list.size())):
			var cur_firefly = fireflies_list.pop_back()
			cur_firefly.unfollow(self)
		
		state_manager._switch_state(state_manager.hurtState)
		
func take_life(firefly_startPos : Vector2, life_increased : int):
	life += life_increased

	var fireflyNode = firefly.instantiate()
	fireflyNode.global_position = firefly_startPos
	get_parent().add_child(fireflyNode)
	fireflyNode.target = self
	fireflies_list.append(fireflyNode)
	
#endregion

func _on_invencibility_timer_timeout() -> void:
	if hurt_invencible:
		hurt_invencible = false

func _on_collectables_detector_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("Firefly_collectable"):
		area.owner.entity_detector.queue_free()
		take_life(area.owner.firefly_sprite_2d.global_position, area.owner.life_increase)
		area.owner.collect()
