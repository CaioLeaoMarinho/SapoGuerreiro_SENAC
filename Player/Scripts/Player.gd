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
	
func _physics_process(_delta):
	move_and_slide()
	
	update_closest_frog_rope()
	
	update_acceleration()
#endregion

#region Custom Methods

func _initilialize_player_components():
	return
	
func update_closest_frog_rope(min_distance := 100.0, max_distance := 1000.0):
	var closest_rope = null
	var closest_distance = max_distance
	var nearby_ropes = []

	var overlapping_areas = frog_rope_detector.get_overlapping_areas()

	for frog_rope in get_tree().get_nodes_in_group("frog_rope"):
		if frog_rope in overlapping_areas:
			var distance = global_position.distance_to(frog_rope.global_position)
			if distance <= max_distance:
				nearby_ropes.append(frog_rope)
			
			if distance < closest_distance and distance >= min_distance:
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
#endregion
