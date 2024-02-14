extends Node

class_name InteractionClient

@export var has_loot = true

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
	player_character.trigger_interaction.connect(trigger_interaction)
	player_character.trigger_loot.connect(loot)
	player_character.raycast.stop_interaction.connect(stop_interaction)
	dialog_box = player_character.dialog_box
	
func initiate_interaction(_name: String):
	if _name == author:
		var message = [screen_play.initial_line]
		if has_loot:
			message.push_back("has loot")
		if !intreaction_started:
			dialog_box.post_message(message)
			intreaction_started = true
	else:
		stop_interaction(author)
		
func trigger_interaction(_interaction_type: InteractionType):
	if intreaction_started:
		match _interaction_type:
			InteractionType.Talk:
				if linenum < screen_play.dialog.size():
					dialog_box.post_dialog(screen_play.dialog[linenum])
				else:
					stop_interaction(author)
				linenum += 1
			InteractionType.Craft:
				dialog_box.post_status_message("craft craft "  + author)
			
		
func stop_interaction(_name: String):
	if intreaction_started && _name == author:
		intreaction_started = false
		dialog_box.clear_message()
		linenum = 0

func loot(hand: Hand.Side):
	if intreaction_started && has_loot:
		player_character.add_item(screen_play.loot, hand)
		has_loot = false
		dialog_box.post_message([screen_play.initial_line])
	
enum InteractionType{
	Talk,
	Craft
}
