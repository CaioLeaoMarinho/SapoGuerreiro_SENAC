extends Node

#region States
@onready var idleState = $Idle
@onready var walkState = $Walk
@onready var jumpState = $Jump
@onready var fallState = $Fall
@onready var hookState = $Hook
@onready var jumpPeakState = $JumpPeak

#endregion

#region Variables
@onready var animation_player = $"../AnimationPlayer"
@onready var Player = $".."

var currentState = null
#endregion

#region Default Methods

func _ready():
	for state in self.get_children():
		state.StateManager = self
		state.Entity = Player
	
	#	INICIALIZA A STATE MACHINE
	currentState = idleState
	_switch_state(currentState)

func _physics_process(delta):
	if currentState != null:
		currentState._update_state(delta)
#endregion

#region State Machine Methods

func _switch_state(nextState):
	if nextState != null and Player.canSwitchState:
		currentState._exit_state()
		currentState = nextState
		currentState._enter_state()
		
		print(currentState.name)
		
		return
	
func _draw():
	currentState._draw_state()
	
func _switch_animation(nextAnimation):
	if nextAnimation != null:
		animation_player.play(nextAnimation)
#endregion

#region Custom Methods
func _get_horizontal_movement():
	Player.moveDirectionX = Input.get_axis("input_left", "input_right")

	if Player.moveDirectionX != 0:
		Player.velocity.x = move_toward(Player.velocity.x, Player.moveDirectionX * Player.currentMoveSpeed, Player.acceleration)
	else:
		Player.velocity.x = move_toward(Player.velocity.x, Player.moveDirectionX * Player.currentMoveSpeed, Player.deceleration)

func _get_jump():
	if Input.is_action_just_pressed("input_jump") and Player.currentJumps < Player.maxJumps:
		_switch_state(jumpState)
		Player.currentJumps += 1

func _get_input_direction():
	if Input.is_action_pressed("input_left"):
		Player.facing = -1
	if Input.is_action_pressed("input_right"):
		Player.facing = 1

func _get_flip_h():
	Player.sprite2d.flip_h = (Player.facing < 0)

func _get_gravity(delta, gravity):
	if not Player.is_on_floor():
		Player.velocity.y += gravity * delta

func _get_falling():
	if not Player.is_on_floor():
		_switch_state(fallState)
	
func _get_landing():
	if Player.is_on_floor():
		Player.in_inertia = false
		Player.currentJumps = 0
		_switch_state(idleState)

func _get_idle():
	if Player.moveDirectionX == 0:
		_switch_state(idleState)

func _get_walk():
	if Player.moveDirectionX != 0:
		_switch_state(walkState)

func _get_jump_peak():
	if Player.velocity.y >= 0:
		_switch_state(jumpPeakState)
	if not Input.is_action_pressed("input_jump"):
		Player.velocity.y *= Player.jumpHeightMult
		_switch_state(jumpPeakState)
		
func _get_frog_hope(delta):
	_process_rope_buffer(delta)
	
	if Input.is_action_just_pressed("input_hook") and Player.can_hook:
		if not Player.can_hook:
			return
		
		Player.current_frog_rope = Player.get_closest_frog_rope()
	
		if Player.current_frog_rope:
			var distance = Player.global_position.distance_to(Player.current_frog_rope.global_position)
		
			if distance >= Player.min_rope_distance:
				_execute_hook()
			else:
				Player.rope_buffered = true
				Player.rope_buffer_timer = Player.rope_buffer_time

func _process_rope_buffer(delta):
	if Player.rope_buffered:
		Player.rope_buffer_timer -= delta
		if Player.rope_buffer_timer <= 0:
			Player.rope_buffered = false
		else:
			Player.current_frog_rope = Player.get_closest_frog_rope()
			
			if Player.current_frog_rope:
				var distance = Player.global_position.distance_to(Player.current_frog_rope.global_position)
				if distance >= Player.min_rope_distance and Player.can_hook:
					_execute_hook()

func _execute_hook():
	Player.current_frog_rope.owner.can_hook = false
	Player.rope_buffered = false
	_switch_state(hookState)
#endregion
