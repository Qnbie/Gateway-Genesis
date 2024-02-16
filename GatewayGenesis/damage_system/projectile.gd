extends RigidBody3D

@export var speed = 20
@onready var hit_vfx = preload("res://damage_system/hit_vfx.tscn")
var made_by_npc:bool
var coll_position

func _on_area_3d_area_entered(area):
	if area.is_in_group("charachter"):
		if made_by_npc != area.Npc:
			spawn_vfx(global_position)
			area.do_damage(area)
			queue_free()

func spawn_vfx(pos):
	var inst = hit_vfx.instantiate()
	inst.global_position = pos
	get_parent().get_parent().add_child(inst)
