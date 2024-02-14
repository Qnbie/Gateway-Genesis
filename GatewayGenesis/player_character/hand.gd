extends Node

class_name Hand

var player_character: PlayerCharacter
var item: Item
var empty = true

func _ready():
	player_character = get_parent()

func get_item_name() -> String:
	if empty:
		return ""
	else:
		return item.name
	
func add_item(given_item: String):
	if !empty:
		remove_child(item)
	var packed_item = load(given_item)
	item = packed_item.instantiate()
	add_child(item)
	empty = false
	print(name + " get a " + item.name)

func drop_item():
	remove_child(item)
	empty = true

func use(side: Hand.Side):
	if empty:
		player_character.loot(side)
	else:
		item.use()

enum Side{
	Left,
	Right
}
