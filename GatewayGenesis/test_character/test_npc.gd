extends CharacterBody3D

var player = null
@export var player_node_path:NodePath

@onready var nav_agent = $NavigationAgent3D

const SPEED = 3.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	player = get_node(player_node_path)

func _physics_process(delta):
	velocity = Vector3.ZERO
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	move_and_slide()
