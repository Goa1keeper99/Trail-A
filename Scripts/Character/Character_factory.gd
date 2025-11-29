extends RefCounted
class_name CharacterFactory

## Factory for creating character instances

static func create_character(character_class_name: String) -> Character:
	var character = Character.new()
	
	# Use enum values directly as integers to avoid circular dependency
	# CharacterClass enum: FIGHTER=0, WIZARD=1, ROGUE=2, CLERIC=3, RANGER=4
	match character_class_name.to_lower():
		"fighter":
			character.character_class = 0  # Character.CharacterClass.FIGHTER
			character.character_name = "Fighter"
			character.strength = 16
			character.constitution = 14
			character.dexterity = 12
			character.intelligence = 8
			character.wisdom = 10
			character.charisma = 10
			character.max_health = 120
			character.current_health = 120
			character.max_mana = 30
			character.current_mana = 30
		"wizard":
			character.character_class = 1  # Character.CharacterClass.WIZARD
			character.character_name = "Wizard"
			character.strength = 8
			character.constitution = 10
			character.dexterity = 12
			character.intelligence = 16
			character.wisdom = 14
			character.charisma = 10
			character.max_health = 80
			character.current_health = 80
			character.max_mana = 100
			character.current_mana = 100
		"rogue":
			character.character_class = 2  # Character.CharacterClass.ROGUE
			character.character_name = "Rogue"
			character.strength = 12
			character.constitution = 12
			character.dexterity = 16
			character.intelligence = 14
			character.wisdom = 10
			character.charisma = 10
			character.max_health = 100
			character.current_health = 100
			character.max_mana = 50
			character.current_mana = 50
		"cleric":
			character.character_class = 3  # Character.CharacterClass.CLERIC
			character.character_name = "Cleric"
			character.strength = 12
			character.constitution = 14
			character.dexterity = 10
			character.intelligence = 10
			character.wisdom = 16
			character.charisma = 12
			character.max_health = 110
			character.current_health = 110
			character.max_mana = 80
			character.current_mana = 80
		"ranger":
			character.character_class = 4  # Character.CharacterClass.RANGER
			character.character_name = "Ranger"
			character.strength = 12
			character.constitution = 12
			character.dexterity = 16
			character.intelligence = 10
			character.wisdom = 14
			character.charisma = 10
			character.max_health = 100
			character.current_health = 100
			character.max_mana = 60
			character.current_mana = 60
		_:
			character.character_class = 0  # Character.CharacterClass.FIGHTER
			character.character_name = "Fighter"
	
	# Initialize skill tree after character is fully set up
	character.initialize_skill_tree()
	character.calculate_derived_stats()
	return character
