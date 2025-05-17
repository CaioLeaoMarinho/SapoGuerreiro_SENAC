extends Node

#region States
@onready var press_startState: Node = $PressStart
@onready var main_menuState: Node = $MainMenu
@onready var play_gameState: Node = $PlayGame
@onready var creditsState: Node = $Credits
@onready var optionsState: Node = $Options
@onready var exitState: Node = $Exit

var currentState = null
#endregion

#region Default Methods

func _ready():
	for state in self.get_children():
		state.StateManager = self
	
	#	INICIALIZA A STATE MACHINE
	currentState = press_startState
	_switch_state(currentState)

func _physics_process(delta):
	if currentState != null:
		currentState._update_state(delta)
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
#endregion

#region State Machine Methods

func _switch_state(nextState):
	if nextState != null:
		currentState._exit_state()
		currentState = nextState
		currentState._enter_state()
		
		print(currentState.name)
		
		return
	
func _draw():
	currentState._draw_state()
#endregion
