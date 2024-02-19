extends Node

class_name DialogBox

var labels: Array = []
var timer: Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(clear_message)

func post_status_message(massage: String):
	post_message([massage])
	timer.start(10)

func post_dialog(message: String):
	clear_message()
	var messages = [message]
	messages.push_back("q > next")
	post_message(messages)

func post_message(messages: Array):
	clear_message()
	for message in messages:
		add_label(message)
	
func add_label(message: String):
	var label = Label.new()
	label.text = message
	add_child(label)
	labels.push_front(label)

func clear_message():
	for label in labels:
		remove_child(label)
	labels.clear()
