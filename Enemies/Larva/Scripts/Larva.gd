extends CharacterBody2D

#region Referencias
@onready var sprite2d = $Sprite2D
@onready var collision2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var state_manager = $StateMachine
@onready var wall_detector = $WallDetector
#endregion

#region Variables
var life : int = 1

var currentMoveSpeed = 3000
var moveDirectionX = -1

var fallGravity = 2000

var canSwitchState = true
#endregion

#region Default Methods
func _ready():
	_initilialize_larva_components()
	
func _physics_process(_delta):
	move_and_slide()
#endregion

#region Custom Methods

func _initilialize_larva_components():
	return
	
func take_damage(damage : int):
	life -= damage
	state_manager._switch_state(state_manager.hurtState)
#endregion
