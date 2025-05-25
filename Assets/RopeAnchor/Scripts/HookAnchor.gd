extends Node2D

@onready var input_icon: Sprite2D = $InputIcon
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var double_clicker_timer: Timer = $DoubleClickerTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

var player = null
var can_change = true
var can_hook = true
const outline_color = Color(1,1,1,1)
const outline_thickness = 5.0

func _ready():
	input_icon.visible = false
	var selfMaterial = sprite_2d.get_material().duplicate()
	sprite_2d.set_material(selfMaterial)
	sprite_2d.get_material().set_shader_parameter("line_color", outline_color)
	sprite_2d.get_material().set_shader_parameter("line_thickness", outline_thickness)
	sprite_2d.get_material().set_shader_parameter("enable_outline", false)

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		if player:
			player = null
			sprite_2d.get_material().set_shader_parameter("enable_outline", false)
			input_icon.visible = false
			double_clicker_timer.stop()

func _process(_delta):
	if player:
		var current_player_frog_rope = player.get_closest_frog_rope()
		
		if current_player_frog_rope and current_player_frog_rope.owner == self:
			sprite_2d.get_material().set_shader_parameter("enable_outline", true)
			input_icon.visible = true
		else:
			sprite_2d.get_material().set_shader_parameter("enable_outline", false)
			input_icon.visible = false


func _on_double_clicker_timer_timeout() -> void:
	can_change = true
