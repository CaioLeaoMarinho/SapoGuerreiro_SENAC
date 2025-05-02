extends CharacterBody2D

#region References
@onready var sprite2d = $Sprite2D
@onready var collision2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var camera_2d = $Camera2D
@onready var state_manager = $StateMachine
@onready var frog_rope_detector = $FrogRopeDetector
#endregion

#region Variables
@export_category("Configurar movimento")
@export var maxMoveSpeed = 500
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
@export var jumpTimeToPeak = 0.5
@export var maxJumps = 1
var currentJumps = 0
@export var jumpHeightMult = 0.5
@export_category("Configurar frog rope")
@export var min_rope_distance = 150
@export var max_rope_distance = 1000
@export var target_rope_speed: float = 500.0
@export var rope_buffer_time: float = 0.2

var rope_buffered = false
var rope_buffer_timer = 0.0

var facing = 1

var canSwitchState = true

var can_hook = true
var current_frog_rope: Node = null
var last_frog_rope: Node = null
var launched_by_rope = false
#endregion

#region Default Methods
func _ready():
	_initilialize_player_components()
	print(global_rotation)
	
func _physics_process(_delta):
	move_and_slide()
	
	update_acceleration()
#endregion

#region Custom Methods

func _initilialize_player_components():
	return
	
func get_valid_frog_ropes() -> Array:
	var valid_ropes = []
	var overlapping_areas = frog_rope_detector.get_overlapping_areas()
	
	for frog_rope in get_tree().get_nodes_in_group("frog_rope"):
		if frog_rope in overlapping_areas:
			var distance = global_position.distance_to(frog_rope.global_position)
			if distance <= max_rope_distance and distance >= min_rope_distance:
				valid_ropes.append(frog_rope)
	
	return valid_ropes
	
func update_closest_frog_rope():
	var closest_rope = null
	var closest_distance = max_rope_distance
	var valid_ropes = get_valid_frog_ropes()

	for frog_rope in valid_ropes:
		var distance = global_position.distance_to(frog_rope.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_rope = frog_rope
	
	current_frog_rope = closest_rope

func update_acceleration():
	if not launched_by_rope:
		acceleration = instantAcceleration
		deceleration = instantDeceleration
	else:
		acceleration = inertiaAcceleration
		deceleration = inertiaDeceleration

func update_rotation():
	if state_manager.currentState != state_manager.hookState:
		rotation = 0
#endregion
