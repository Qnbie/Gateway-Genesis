extends Control

@onready var door_laps = $"../../../door_root/lap_root".get_children()
@onready var door_kerets = $"../../../door_root/keret_root".get_children()
@onready var door_zars = $"../../../door_root/zar_root".get_children()

var curr_door_lap = 0
var curr_door_keret = 0
var curr_door_zar = 0

func _ready():
	pass 

func cicle_objects(objects, counter, direction):
	if counter == objects.size() - 1:
		counter = 0
	if counter < 0:
		counter = 0
	objects[counter].visible = false
	counter += direction
	objects[counter].visible = true


func _on_kert_r_pressed():
	%keret_Animation.play("keret_in")

func _on_lap_r_pressed():
	%lap_Animation.play("lap_in")

func _on_zar_r_pressed():
	%zar_Animation.play("zar_in")

