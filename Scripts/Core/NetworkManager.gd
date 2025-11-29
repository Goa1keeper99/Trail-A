extends Node

## Handles multiplayer networking using Godot's Multiplayer API

const PORT = 7777
const MAX_PLAYERS = 4

signal player_connected(player_id: int)
signal player_disconnected(player_id: int)

var players: Dictionary = {}

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func host_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_PLAYERS)
	if error != OK:
		print("Failed to create server: ", error)
		return false
	
	multiplayer.multiplayer_peer = peer
	print("Server started on port ", PORT)
	players[1] = {"id": 1, "character": null}
	return true

func join_game(ip: String):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip, PORT)
	if error != OK:
		print("Failed to create client: ", error)
		return false
	
	multiplayer.multiplayer_peer = peer
	print("Connecting to ", ip, ":", PORT)
	return true

func _on_peer_connected(id: int):
	print("Peer connected: ", id)
	player_connected.emit(id)
	players[id] = {"id": id, "character": null}

func _on_peer_disconnected(id: int):
	print("Peer disconnected: ", id)
	player_disconnected.emit(id)
	players.erase(id)

func _on_connected_to_server():
	print("Connected to server as peer: ", multiplayer.get_unique_id())
	players[multiplayer.get_unique_id()] = {"id": multiplayer.get_unique_id(), "character": null}

func _on_connection_failed():
	print("Connection failed")

func _on_server_disconnected():
	print("Server disconnected")
	players.clear()

func is_host() -> bool:
	return multiplayer.is_server()

func get_player_count() -> int:
	return players.size()
