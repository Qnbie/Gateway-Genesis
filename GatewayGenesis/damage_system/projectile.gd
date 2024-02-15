extends RigidBody3D

@export var speed = 20

var made_by_npc:bool

func _on_area_3d_area_entered(area):
	if area.is_in_group("charachter"):
		if made_by_npc != area.Npc:
			area.do_damage(area)
			queue_free()
