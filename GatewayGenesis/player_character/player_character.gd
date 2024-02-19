extends CharacterBody3D

class_name PlayerCharacter

@export var god_mod: bool = false
@export var camera: Camera3D;
@export var raycast: PlayerRayCast;
@export var dialog_box: DialogBox;
@export var right_hand: Hand
@export var left_hand: Hand

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var knock_back = Vector3.ZERO

signal meele_attack

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_sensitivity = 0.002

signal trigger_dialog()
signal trigger_craft(items: Array)
signal trigger_loot(hand: Hand.Side)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var collisionmap = Collisionmap.new()
	collisionmap.physics_body = self
	var playground = get_node("../Playground")
	if playground == null:
		print("playground is null")
	playground.add_child(collisionmap)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		emit_signal("meele_attack")
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("interaction_talk"):
		trigger_dialog.emit()
	if Input.is_action_just_pressed("interaction_craft"):
		trigger_craft.emit([
			right_hand.get_item_name(),
			left_hand.get_item_name()])

	if Input.is_action_just_pressed("hand_left"):
		left_hand.use(Hand.Side.Left)
	if Input.is_action_just_pressed("hand_right"):
		right_hand.use(Hand.Side.Right)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED + knock_back.x
		velocity.z = direction.z * SPEED + knock_back.z
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	velocity += knock_back
	knock_back = lerp(knock_back, Vector3.ZERO, 0.1)
	move_and_slide()

func loot(hand: Hand.Side):
	trigger_loot.emit(hand)

func add_item(item: String, hand: Hand.Side):
	match hand:
		Hand.Side.Left:
			left_hand.add_item(item)
		Hand.Side.Right:
			right_hand.add_item(item)

func exchange_item(recipie: Array):
	for i in range(recipie.size() - 1):
		if recipie[i] == right_hand.get_item_name():
			right_hand.drop_item()
			continue
		if recipie[i] == left_hand.get_item_name():
			left_hand.drop_item()
	if right_hand.empty:
		right_hand.add_item(recipie[recipie.size() - 1])
	else:
		left_hand.add_item(recipie[recipie.size() - 1])
