extends Area3D

class_name Damage_system

@export var Npc:bool
@export var hit_points = 100
@export_enum("Ranged", "Melee") var attack_type:String = "Melee"
@export var meele_range = -1.9
@export var meele_damage = 20
@export var knockback_strength = 10
@export var num_of_bullets = 4
@export var bullet_density = 0.2
@export var projectal:PackedScene

@onready var melee_ray = $Melee_ray
@onready var pr_spawn = $projectal_spawn
#@onready var projectal = preload("res://damage_system/projectile.tscn")

func _ready():
	$bullet_density_cd.wait_time = bullet_density
	if not Npc:
		pr_spawn = $"../Camera3d/projectal_spawn"
	$Melee_ray.target_position.y = meele_range
	if Npc:
		if attack_type == "Melee":
			$"../Root Scene".attack_point.connect(try_melee)
		if attack_type == "Ranged":
			$"../Root Scene".attack_point.connect(projectal_spray)
	if not Npc:
		$"..".meele_attack.connect(spawn_projectal)

func _physics_process(delta):
	if hit_points < 0 and Npc:
		get_parent().anim_tree.set("parameters/conditions/death", true)

func knock_back(target):
	var direction = global_position.direction_to(target.global_position).normalized()
	var explosion_force = direction * knockback_strength
	explosion_force.y = 0.2
	target.get_parent().knock_back = explosion_force

func do_damage(target):
	target.hit_points -= meele_damage
	print(target.hit_points)
	if target.Npc:
		target.get_parent().anim_tree.set("parameters/conditions/hit", true)

func try_melee():
	print(melee_ray.get_collider())
	if melee_ray.get_collider() != null:
		if melee_ray.get_collider().is_class("Area3D") and melee_ray.get_collider().is_in_group("charachter"):
			var target = melee_ray.get_collider()
			do_damage(target)
			knock_back(target)

func spawn_projectal():
	if not $shoot_cd.is_stopped() and not Npc:
		return
	var inst = projectal.instantiate()
	inst.made_by_npc = Npc
	if Npc:#get_parent().player_character.global_position
		pr_spawn.look_at_from_position(pr_spawn.global_position, (get_parent().player_character.global_position + Vector3(0,2,0)), Vector3.LEFT)
	inst.transform = pr_spawn.global_transform
	inst.linear_velocity = -pr_spawn.global_transform.basis.z * inst.speed
	get_parent().get_parent().add_child(inst)
	$shoot_cd.start()

func projectal_spray():
	for i in num_of_bullets:
		$bullet_density_cd.start()
		spawn_projectal()
		await $bullet_density_cd.timeout
