extends MeshInstance3D

@onready var collison = $StaticBody3D/CollisionShape3D

func _ready():
	generate_new_terrain()

func generate_new_terrain():
	var fast_noise_lite = FastNoiseLite.new()
	
	var texture = NoiseTexture2D.new()
	texture.noise = fast_noise_lite
	texture.normalize = true
	
	set_up_collision_shape(fast_noise_lite, 32, 32)
	mesh.material.set_shader_parameter("noise", texture)

func set_up_collision_shape(fnl: FastNoiseLite, depth: int, width: int):
	var h_map_shape = HeightMapShape3D.new()
	var packed_float_array = PackedFloat32Array()
	for x in range(depth):
		for y in range(width):
			packed_float_array.append(fnl.get_noise_2d(x,y) * 5)

	
	h_map_shape.map_depth = depth
	h_map_shape.map_width = width
	h_map_shape.map_data = packed_float_array
	collison.shape = h_map_shape
