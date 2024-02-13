extends Node

class_name DialogBoxClient

var dialog_box: DialogBox
var author: String

func set_up(_dialog_box: DialogBox, _author: String):
	dialog_box = _dialog_box
	author = _author

func send_message(text: String):
	var message = Message.new()
	message.author = author
	message.text = text
	dialog_box.get_message(message)

func disconnect_dialogbox():
	dialog_box.disconnect_author(author)
