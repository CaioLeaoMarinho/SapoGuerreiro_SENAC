extends CharacterBody2D

#region Referencias
@onready var sprite2d = $AnimatedSprite2D
@onready var collision2d = $CollisionShape2D
#endregion

#region Variables

var runSpeed = 400
var moveSpeed = runSpeed
var acceleration = 40
var deceleration= 15
var moveDirectionX = 0

const gravity = 400

var jumpVelocity = -300
var maxJumps = 1
var currentJumps = 0

var facing = 1
#endregion

#region Default Methods

func _ready():
	pass

func _physics_process(delta):
	# Facing System
	if Input.is_action_pressed("input_left"):
		facing = -1
	if Input.is_action_pressed("input_right"):
		facing = 1
	# Gravity System
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		currentJumps = 0
	_horizontal_movement()
	_jump()
	move_and_slide()
#endregion

#region Custom Methods

func _horizontal_movement():
	moveDirectionX = Input.get_axis("input_left", "input_right")
	
	if moveDirectionX != 0:
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, deceleration)
	
	sprite2d.flip_h = (facing < 0)
	
	if is_on_floor():
		if velocity.x != 0:
			sprite2d.play("walk")
		else:
			sprite2d.play("idle")
	else:
		if velocity.y < 0:
			sprite2d.play("jump")
		else:
			sprite2d.play("fall")
			
func _jump():
	if Input.is_action_pressed("input_jump"):
		if currentJumps < maxJumps:
			velocity.y  = jumpVelocity
			currentJumps += 1
#endregion
