extends CharacterBody3D

signal attack_point

func attack_point_reached():
	emit_signal("attack_point")


