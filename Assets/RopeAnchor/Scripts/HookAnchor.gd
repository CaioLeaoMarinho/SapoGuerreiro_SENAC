extends Sprite2D

@onready var input_icon: Sprite2D = $Cross

var player = null
var can_hook = true
const outline_color = Color(1,1,1,1)
const outline_thickness = 2.0

func _ready():
	input_icon.visible = false
	var selfMaterial = self.get_material().duplicate()
	self.set_material(selfMaterial)
	self.get_material().set_shader_parameter("line_color", outline_color)
	self.get_material().set_shader_parameter("line_thickness", outline_thickness)

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		if player:
			player = null
			self.get_material().set_shader_parameter("enable_outline", false)
			input_icon.visible = false

func _process(_delta):
	if player:
		var current_player_frog_rope = player.get_closest_frog_rope()
		
		if current_player_frog_rope and current_player_frog_rope.owner == self:
			self.get_material().set_shader_parameter("enable_outline", true)
			input_icon.visible = true
		else:
			self.get_material().set_shader_parameter("enable_outline", false)
			input_icon.visible = false
