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
		var current_player_frog_rope = player.get_closest_frog_rope()
		print("self: ",self)
		print("current frog rope: ",current_player_frog_rope)
		
		if current_player_frog_rope and current_player_frog_rope.owner == self:
			self.get_material().set_shader_parameter("enable_outline", true)
	else:
		self.get_material().set_shader_parameter("enable_outline", false)
