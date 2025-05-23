extends Node

#region States
@onready var idleState = $Idle
@onready var walkState = $Walk
@onready var jumpState = $Jump
@onready var fallState = $Fall
@onready var hookState = $Hook
@onready var jumpPeakState = $JumpPeak
@onready var hurtState: Node = $Hurt
@onready var dieState: Node = $Die
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
		
	#if Input.is_action_just_pressed("ui_cancel"):
		#get_tree().quit()
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
	if not Player.in_transition:
		Player.moveDirectionX = Input.get_axis("input_left", "input_right")

		if Player.moveDirectionX != 0:
			Player.velocity.x = move_toward(Player.velocity.x, Player.moveDirectionX * Player.currentMoveSpeed, Player.acceleration)
		else:
			Player.velocity.x = move_toward(Player.velocity.x, Player.moveDirectionX * Player.currentMoveSpeed, Player.deceleration)

func _get_jump():
	if not Player.in_transition:
		if Player.is_on_floor():
			if Player.currentJumps < Player.maxJumps:
				if Input.is_action_just_pressed("input_jump") or Player.jump_buffer_timer.time_left > 0:
					Player.jump_buffer_timer.stop()
					Player.currentJumps += 1
					_switch_state(jumpState)
		else:
			if Player.currentJumps < Player.maxJumps and Player.currentJumps > 0 and Input.is_action_just_pressed("input_jump"):
				Player.currentJumps += 1
				_switch_state(jumpState)
			if Player.coyote_jump_timer.time_left > 0:
				if Input.is_action_just_pressed("input_jump") and Player.currentJumps < Player.maxJumps:
					Player.coyote_jump_timer.stop()
					Player.currentJumps += 1
					_switch_state(jumpState)

func _get_input_direction():
	if not Player.in_transition:
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
		Player.coyote_jump_timer.start()
		_switch_state(fallState)

func _get_landing():
	if Player.is_on_floor():
		Player.in_inertia = false
		Player.launched_by_rope = false
		Player.currentJumps = 0
		_switch_state(idleState)

func _get_idle():
	if Player.moveDirectionX == 0:
		_switch_state(idleState)

func _get_walk():
	if not Player.in_transition:
		if Player.moveDirectionX != 0:
			_switch_state(walkState)

func _get_jump_peak():
	if Player.velocity.y >= 0:
		_switch_state(fallState)
	if not Input.is_action_pressed("input_jump"):
		Player.velocity.y *= Player.jumpHeightMult
		_switch_state(fallState)

func _get_frog_hope(delta):
	if not Player.in_transition:
		_process_rope_buffer(delta)
	
		if Input.is_action_just_pressed("input_hook") and Player.can_hook:
			if not Player.can_hook:
				return
		
			Player.current_frog_rope = Player.get_closest_frog_rope()
	
			if Player.current_frog_rope and Player.current_frog_rope.owner.double_clicker_timer.time_left <= 0:
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
	Player.current_frog_rope.owner.animation_player.play("hooked")
	Player.rope_buffered = false
	_switch_state(hookState)

func die():
	_switch_state(dieState)

func _get_jump_buffer():
	if not Player.in_transition:
		if Input.is_action_just_pressed("input_jump"):
			Player.jump_buffer_timer.start()
			
func _get_in_transition():
	if Player.in_transition:
		_switch_state(idleState)
#endregion
