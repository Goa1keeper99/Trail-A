extends Control
class_name CharacterSelectUI

## UI for character selection screen

@onready var fighter_button = $VBoxContainer/FighterButton
@onready var wizard_button = $VBoxContainer/WizardButton
@onready var rogue_button = $VBoxContainer/RogueButton
@onready var cleric_button = $VBoxContainer/ClericButton
@onready var ranger_button = $VBoxContainer/RangerButton

signal character_selected(character_class: String)

func _ready():
	fighter_button.pressed.connect(_on_fighter_selected)
	wizard_button.pressed.connect(_on_wizard_selected)
	rogue_button.pressed.connect(_on_rogue_selected)
	cleric_button.pressed.connect(_on_cleric_selected)
	ranger_button.pressed.connect(_on_ranger_selected)

func _on_fighter_selected():
	character_selected.emit("Fighter")

func _on_wizard_selected():
	character_selected.emit("Wizard")

func _on_rogue_selected():
	character_selected.emit("Rogue")

func _on_cleric_selected():
	character_selected.emit("Cleric")

func _on_ranger_selected():
	character_selected.emit("Ranger")
