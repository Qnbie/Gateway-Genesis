extends Node

class_name ScreenPlay

var title: String
var initial_line: String
var content: Array
var loot: String

func load_json(json_resource: Resource):
	var file = FileAccess.open(json_resource.resource_path, FileAccess.READ)
	var json = JSON.new()
	var data = json.parse_string(file.get_as_text())
	title = data.title
	initial_line = data.initial_line
	content = data.content
	loot = data.loot
