extends Control

@onready var door_laps = %lap_root.get_children()
@onready var door_kerets = %keret_root.get_children()
@onready var door_zars = %zar_root.get_children()

@onready var door_parts = [&"keret_sivatag", &"lap_kokor", &"zar_bronz"]

var curr_door_lap = 0
var curr_door_keret = 0
var curr_door_zar = 0

func _ready():
	pass 

func cicle_objects(objects, direction, counter):
	objects[counter].visible = false
	counter += direction
	if counter == objects.size():
		counter = 0
	if counter == -1:
		counter = 2
	objects[counter].visible = true
	return counter


func _on_kert_r_pressed():
	curr_door_keret = cicle_objects(door_kerets, 1, curr_door_keret)
	door_parts[0] = door_kerets[curr_door_keret].name
	print(door_parts)
	%keret_Animation.stop()
	%keret_Animation.play("keret_in")

func _on_lap_r_pressed():
	curr_door_lap = cicle_objects(door_laps, 1, curr_door_lap)
	door_parts[1] = door_laps[curr_door_lap].name
	print(door_parts)
	%lap_Animation.stop()
	%lap_Animation.play("lap_in")

func _on_zar_r_pressed():
	curr_door_zar = cicle_objects(door_zars, 1, curr_door_zar)
	door_parts[2] = door_zars[curr_door_zar].name
	print(door_parts)
	%zar_Animation.stop()
	%zar_Animation.play("zar_in")


func _on_kert_l_pressed():
	curr_door_keret = cicle_objects(door_kerets, -1, curr_door_keret)
	door_parts[0] = door_kerets[curr_door_keret].name
	print(door_parts)
	%keret_Animation.stop()
	%keret_Animation.play("keret_in")

func _on_lap_l_pressed():
	curr_door_lap = cicle_objects(door_laps, -1, curr_door_lap)
	door_parts[1] = door_laps[curr_door_lap].name
	print(door_parts)
	%lap_Animation.stop()
	%lap_Animation.play("lap_in")

func _on_zar_l_pressed():
	curr_door_zar = cicle_objects(door_zars, -1, curr_door_zar)
	door_parts[2] = door_zars[curr_door_zar].name
	print(door_parts)
	%zar_Animation.stop()
	%zar_Animation.play("zar_in")
