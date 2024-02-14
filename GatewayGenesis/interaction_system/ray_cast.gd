extends RayCast3D

class_name PlayerRayCast

const RAY_LENGTH = 1000
const TRIGGER_DISTANCE = 200

signal initiate_interaction(target: String)
signal stop_interaction(target: String)

@export var cam: Camera3D
var last_collide: String

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	if result:
		last_collide = result.collider.name
		initiate_interaction.emit(last_collide)
	else:
		stop_interaction.emit(last_collide)
