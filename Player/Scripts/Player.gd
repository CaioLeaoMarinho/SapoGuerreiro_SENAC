extends CharacterBody2D

#region Referencias
@onready var sprite2d = $Sprite2D
@onready var collision2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var camera_2d = $Camera2D
@onready var state_manager = $StateMachine
@onready var coyote_timer = $Timers/CoyoteTimer

#endregion

#region Variables

var runSpeed = 400
var moveSpeed = runSpeed
var acceleration = 40
var deceleration= 15
var moveDirectionX = 0

const jumpGravity = 600
const fallGravity = 750
const maxFallVelocity = 400
var jumpVelocity = -500
var maxJumps = 1
var currentJumps = 0

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
	for state in state_manager.get_children():
		state.StateManager = state_manager
		state.Player = self
#endregion
