extends Node

class_name DialogBox

var message_labels: Array = []

func get_message(message: Message):
	var msg = [message, add_new_label(message.text)]
	message_labels.push_front(msg)

func disconnect_author(author: String):
	var i = 0
	while i < message_labels.size():
		if message_labels[i][0].author == author:
			remove_child(message_labels[i][1])
			message_labels.remove_at(i)
		else:
			i+=1

func add_new_label(text: String):
	var label = Label.new()
	label.text = text
	add_child(label)
	return label
