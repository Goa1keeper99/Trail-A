extends Control
class_name SkillTreeUI

## UI for displaying and interacting with skill trees

var character: Character = null
var skill_buttons: Dictionary = {}

@onready var skill_container = $ScrollContainer/VBoxContainer
@onready var close_button = $CloseButton

func _ready():
	close_button.pressed.connect(hide)

func setup(character_instance: Character):
	character = character_instance
	update_skill_tree()

func update_skill_tree():
	# Clear existing buttons
	for child in skill_container.get_children():
		child.queue_free()
	skill_buttons.clear()
	
	if not character or not character.skill_tree:
		return
	
	# Create buttons for each skill
	for skill_id in character.skill_tree.skills:
		var skill = character.skill_tree.get_skill(skill_id)
		var button = Button.new()
		button.text = skill.name + " (Tier " + str(skill.tier) + ")"
		button.custom_minimum_size = Vector2(300, 50)
		
		# Check if skill is unlocked
		if skill_id in character.unlocked_skills:
			button.disabled = true
			button.text += " [UNLOCKED]"
		else:
			# Check if prerequisites are met
			var can_unlock = true
			for prereq in skill.prerequisites:
				if prereq not in character.unlocked_skills:
					can_unlock = false
					break
			
			if not can_unlock:
				button.disabled = true
			else:
				button.pressed.connect(_on_skill_selected.bind(skill_id))
		
		skill_container.add_child(button)
		skill_buttons[skill_id] = button

func _on_skill_selected(skill_id: String):
	if character and character.unlock_skill(skill_id):
		update_skill_tree()
