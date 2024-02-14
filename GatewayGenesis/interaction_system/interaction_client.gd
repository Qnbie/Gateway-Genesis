extends Node

class_name InteractionClient

var intreaction_started: bool = false
var linenum: int = 0
var initiate_line: String
var author: String
var dialog_box: DialogBox
var screen_play: ScreenPlay

func set_up(
	player_character: PlayerCharacter, 
	_author: String, 
	_screen_play: ScreenPlay):
	author = _author
	screen_play = _screen_play
	player_character.raycast.initiate_interaction.connect(initiate_interaction)
	player_character.trigger_interaction.connect(trigger_interaction)
	player_character.raycast.stop_interaction.connect(stop_interaction)
	dialog_box = player_character.dialog_box
	
func initiate_interaction(_name: String):
	if _name == author:
		if !intreaction_started:
			print("initaite " + author)
			dialog_box.post_message([screen_play.initial_line])
			intreaction_started = true
	else:
		stop_interaction(author)
		
func trigger_interaction(_interaction_type: InteractionType):
	if intreaction_started:
		match _interaction_type:
			InteractionType.Talk:
				if linenum < screen_play.content.size():
					dialog_box.post_dialog(screen_play.content[linenum])
				else:
					stop_interaction(author)
				linenum += 1
			InteractionType.Craft:
				dialog_box.post_status_message("craft craft "  + author)
	
		
func stop_interaction(_name: String):
	if intreaction_started && _name == author:
		print("stop")
		intreaction_started = false
		dialog_box.clear_message()
		linenum = 0

enum InteractionType{
	Talk,
	Craft	
}
