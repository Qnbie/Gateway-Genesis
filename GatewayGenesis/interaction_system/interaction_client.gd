extends Node

class_name InteractionClient

var triggered: bool = false
var initiate_line: String
var dialog_box_client: DialogBoxClient
var author: String
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
	dialog_box_client = DialogBoxClient.new()
	dialog_box_client.set_up(player_character.dialog_box, author)
	
func initiate_interaction(_name: String):
	if _name == author:
		if !triggered:
			dialog_box_client.send_message(screen_play.initial_line)
			triggered = true
	else:
		stop_interaction(author)
		
func trigger_interaction(_interaction_type: InteractionType):
	match _interaction_type:
		InteractionType.Talk:
			dialog_box_client.send_message("talk talk " + author)
		InteractionType.Craft:
			dialog_box_client.send_message("craft craft "  + author)
	
		
func stop_interaction(_name: String):
	if _name == author:
		triggered = false
		dialog_box_client.disconnect_dialogbox()

enum InteractionType{
	Talk,
	Craft	
}
