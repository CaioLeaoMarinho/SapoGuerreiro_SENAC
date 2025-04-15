extends CharacterBody2D

#region Referencias
@onready var sprite2d = $Sprite2D
@onready var collision2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var camera_2d = $Camera2D
@onready var state_manager = $StateMachine
#endregion

#region Variables
var maxMoveSpeed = 500
var currentMoveSpeed = maxMoveSpeed
var acceleration = 100
var deceleration = 100
var moveDirectionX = 0

var jumpGravity = 0
var fallGravity = 2000
var jumpVelocity = 0
var jumpHeight = 200
var jumpTimeToPeak = 0.5
var maxJumps = 1
var currentJumps = 0
const jumpHeightMult = 0.5

var facing = 1

var canSwitchState = true
#endregion

#region Default Methods
func _ready():
	_initilialize_player_components()
	
func _physics_process(_delta):
	move_and_slide()
#endregion

#region Custom Methods

func _initilialize_player_components():
	return
#endregion
