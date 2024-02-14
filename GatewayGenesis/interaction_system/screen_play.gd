extends Node

class_name ScreenPlay

var title: String
var initial_line: String
var content: Array

func load_json(file_name: String):
	var file = FileAccess.open("res://interaction_system/screen_play_library/" + file_name, FileAccess.READ)
	var json = JSON.new()
	var data = json.parse_string(file.get_as_text())
	title = data.title
	initial_line = data.initial_line
	content = data.content
