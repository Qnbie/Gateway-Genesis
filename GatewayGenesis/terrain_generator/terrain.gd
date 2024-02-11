extends MeshInstance3D


var tmp = 0.5

func _ready():
	generate_new_terrain()

func generate_new_terrain():
	var fast_noise_lite = FastNoiseLite.new()
	fast_noise_lite.seed = randi_range(1, 10)
	var texture = NoiseTexture2D.new()
	texture.noise = fast_noise_lite
	texture.normalize = true
	texture.generate_mipmaps = true
	
	mesh.material.set_shader_parameter("noise", texture)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			print("T was pressed")
			generate_new_terrain()

