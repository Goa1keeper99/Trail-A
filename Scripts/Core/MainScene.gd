extends Node3D

## Main scene controller

@onready var menu = $UI/Menu
@onready var host_button = $UI/Menu/HostButton
@onready var join_button = $UI/Menu/JoinButton
@onready var character_select_button = $UI/Menu/CharacterSelectButton
@onready var start_button = $UI/Menu/StartButton
@onready var quit_button = $UI/Menu/QuitButton

var selected_character: String = "Fighter"

func _ready():
	if host_button:
		host_button.pressed.connect(_on_host_pressed)
	if join_button:
		join_button.pressed.connect(_on_join_pressed)
	if character_select_button:
		character_select_button.pressed.connect(_on_character_select_pressed)
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

func _on_host_pressed():
	if NetworkManager.host_game():
		print("Game hosted successfully")

func _on_join_pressed():
	# In a real implementation, show IP input dialog
	var ip = "127.0.0.1"
	if NetworkManager.join_game(ip):
		print("Joining game...")

func _on_character_select_pressed():
	# Show character select UI
	var char_select = preload("res://scenes/ui/CharacterSelectUI.tscn").instantiate()
	add_child(char_select)
	char_select.character_selected.connect(_on_character_selected)

func _on_character_selected(character_class: String):
	selected_character = character_class
	print("Selected character: ", character_class)

func _on_start_pressed():
	GameManager.start_new_run(selected_character)
	# Load game scene
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_quit_pressed():
	get_tree().quit()
