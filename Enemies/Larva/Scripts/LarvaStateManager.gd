extends Node

#region States
@onready var walkState = $Walk
@onready var dieState: Node = $Die
@onready var hurtState: Node = $Hurt
#endregion

#region References
@onready var animation_player = $"../AnimationPlayer"
@onready var Larva = $".."
#endregion

#region Variables
var currentState = null
#endregion

#region Default Methods
func _ready():
	for state in self.get_children():
		state.StateManager = self
		state.Entity = Larva
	
	#	INICIALIZA A STATE MACHINE
	currentState = walkState
	_switch_state(currentState)
	
func _physics_process(delta):
	if currentState != null:
		currentState._update_state(delta)
#endregion	

#region State Machine Methods	
func _switch_state(nextState):
	if nextState != null and Larva.canSwitchState:
		currentState._exit_state()
		currentState = nextState
		currentState._enter_state()
		
func _draw():
	currentState._draw_state()
	
func _switch_animation(nextAnimation):
	if nextAnimation != null:
		animation_player.play(nextAnimation)
#endregion

#region Custom Methods
func _get_flip_h():
	if (Larva.moveDirectionX > 0):
		Larva.sprite2d.flip_h = true
	else:
		Larva.sprite2d.flip_h = false
	
func _horizontal_movement(delta: float):
	Larva.velocity.x = Larva.moveDirectionX * Larva.currentMoveSpeed * delta
		
func die():
	_switch_state(dieState)
	
func _get_gravity(delta, gravity):
	if not Larva.is_on_floor():
		Larva.velocity.y += gravity * delta
		
func _get_landing():
	if Larva.is_on_floor():
		_switch_state(walkState)
#endregion

func cause_damage(victim : Node2D):
	victim.take_damage(Larva.damage, Larva.global_position)
