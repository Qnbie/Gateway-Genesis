extends Node

class_name DialogBox

var labels: Array = []

func post_message(message: String):
	var label = Label.new()
	label.text = message
	add_child(label)
	labels.push_front(label)

func clear_message():
	for label in labels:
		remove_child(label)
	labels.clear()
