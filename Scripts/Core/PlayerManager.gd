extends Node

## Manages player instances and their data

var local_player: Player = null
var remote_players: Dictionary = {}

func create_player(player_id: int, character_class: String, is_local: bool = false) -> Player:
	var character = CharacterFactory.create_character(character_class)
	var player = preload("res://scenes/Player.tscn").instantiate()
	player.setup(player_id, character, is_local)
	
	if is_local:
		local_player = player
	else:
		remote_players[player_id] = player
	
	return player

func remove_player(player_id: int):
	if remote_players.has(player_id):
		remote_players[player_id].queue_free()
		remote_players.erase(player_id)

func get_all_players() -> Array:
	var all_players = []
	if local_player:
		all_players.append(local_player)
	for player in remote_players.values():
		all_players.append(player)
	return all_players
