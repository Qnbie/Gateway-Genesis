extends Node

class_name InteractionClient

var intreaction_started: bool = false
var linenum: int = 0
var initiate_line: String
var author: String
var dialog_box: DialogBox
var screen_play: ScreenPlay
var player_character: PlayerCharacter

func set_up(
	_player_character: PlayerCharacter, 
	_author: String, 
	_screen_play: ScreenPlay):
	author = _author
	player_character = _player_character
	screen_play = _screen_play
	player_character.raycast.initiate_interaction.connect(initiate_interaction)
	player_character.trigger_dialog.connect(start_dialog)
	player_character.trigger_craft.connect(start_craft)
	player_character.trigger_loot.connect(loot)
	player_character.raycast.stop_interaction.connect(stop_interaction)
	dialog_box = player_character.dialog_box
	
func has_loot() -> bool:
	if screen_play.loot == "":
		return false
	return true

func initiate_interaction(_name: String):
	if _name == author:
		var message = [screen_play.initial_line]
		if has_loot():
			message.push_back("has loot")
		if !intreaction_started:
			dialog_box.post_message(message)
			intreaction_started = true
	else:
		stop_interaction(author)
		
func start_dialog():
	if intreaction_started:
		if linenum < screen_play.dialog.size():
			dialog_box.post_dialog(screen_play.dialog[linenum])
		else:
			stop_interaction(author)
		linenum += 1
		
func start_craft(items: Array):
	if intreaction_started:	
		var correct_items = 0
		for item in items:
			if screen_play.recipie.has(item):
				correct_items+=1
				
		if correct_items == screen_play.recipie.size() - 1:
			player_character.exchange_item(screen_play.recipie)
		else:
			var message = "I need more"
			for i in range(screen_play.recipie.size() - 1):
				message += " " + screen_play.recipie[i]
				if i != screen_play.recipie.size() - 2:
					message += " and"
			dialog_box.post_status_message(message)
		
func stop_interaction(_name: String):
	if intreaction_started && _name == author:
		intreaction_started = false
		dialog_box.clear_message()
		linenum = 0

func loot(hand: Hand.Side):
	if intreaction_started && has_loot():
		player_character.add_item(screen_play.loot, hand)
		screen_play.loot = ""
		dialog_box.post_message([screen_play.initial_line])
