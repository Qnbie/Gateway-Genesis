extends CharacterBody3D

var player_character: PlayerCharacter
var interaction_client: InteractionClient

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_play = ScreenPlay.new()
	screen_play.load_json("test.json")
	player_character = get_parent_node_3d().get_player_character()
	interaction_client = InteractionClient.new()
	interaction_client.set_up(player_character, name, screen_play)
