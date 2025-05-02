extends Sprite2D

var player = null
var can_hook = true
const outline_color = Color(0,0,0,1)
const outline_thickness = 2.0

func _ready():
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

func _process(delta):
	if player:

		var valid_ropes = player.get_valid_frog_ropes()
		var is_valid = false
		
		for rope in valid_ropes:
			if rope.owner == self:
				is_valid = true
				break

		self.get_material().set_shader_parameter("enable_outline", is_valid)
	else:
		self.get_material().set_shader_parameter("enable_outline", false)
