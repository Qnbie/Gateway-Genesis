extends CharacterBody3D

@export var player_character: CharacterBody3D
@export var hostile = true
@export var screen_play_path: Resource

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = get_node("Root Scene").get_child(2)

const SPEED = 3.0
const ATTACK_RANGE = 2.0

var rng = RandomNumberGenerator.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var interaction_client: InteractionClient
var stationary = false
var random_target_valid
var state_machine

func _ready():
	$wait_Timer.start()
	state_machine = anim_tree.get("parameters/playback")
	var screen_play = ScreenPlay.new()
	screen_play.load_json(screen_play_path)
	interaction_client = InteractionClient.new()
	interaction_client.set_up(player_character, name, screen_play)

func _physics_process(delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"run":
			nav_agent.set_target_position(player_character.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			safe_look_at(self,player_character.global_transform.origin)
			move_and_slide()
		"attak":
			do_attack()
		"walk":
			nav_agent.set_target_position(random_target_valid)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			safe_look_at(self,random_target_valid)
			move_and_slide()
			if nav_agent.is_target_reached():
				$wait_Timer.start()
				anim_tree.set("parameters/conditions/walk", false)
				anim_tree.set("parameters/conditions/idle", true)
		"idle":
			rng.randomize()
			if $wait_Timer.get_time_left() == 0 and not stationary:
				random_walk()
				if nav_agent.is_target_reachable():
					anim_tree.set("parameters/conditions/idle", false)
					anim_tree.set("parameters/conditions/walk", true)
				else:
					print("can't reach :C")
					$wait_Timer.start()
		"hit":
			pass
		
		"talk":
			safe_look_at(self,player_character.global_transform.origin)
	
	anim_tree.set("parameters/conditions/run", hostile)
	anim_tree.set("parameters/conditions/attack", target_in_range())


func safe_look_at(node : Node3D, target : Vector3) -> void:
	var origin : Vector3 = node.global_transform.origin
	var v_z := (origin - target).normalized()

	# Just return if at same position
	if origin == target:
		return

	# Find an up vector that we can rotate around
	var up := Vector3.UP
	for entry in [Vector3.UP, Vector3.RIGHT, Vector3.BACK]:
		var v_x : Vector3 = entry.cross(v_z).normalized()
		if v_x.length() != 0:
			up = entry
			break

	# Look at the target
	if up != Vector3.ZERO:
		node.look_at(Vector3(target.x, global_position.y, target.z), up)

func target_in_range():
	return global_position.distance_to(player_character.global_position) < ATTACK_RANGE

func random_walk():
	var random_target = Vector3((global_position.x + rng.randi_range(-20, 20)), global_position.y, (global_position.z + rng.randi_range(-20, 20)))
	random_target_valid = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), random_target)
	print(random_target_valid)

func do_attack():
	pass

