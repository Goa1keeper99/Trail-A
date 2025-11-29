extends Resource
class_name Character

## Base character class with stats, leveling, and skill trees

signal leveled_up(new_level: int)
signal experience_gained(amount: int)
signal skill_unlocked(skill_id: String)

enum CharacterClass {
	FIGHTER,
	WIZARD,
	ROGUE,
	CLERIC,
	RANGER
}

@export var character_class: CharacterClass = CharacterClass.FIGHTER
@export var character_name: String = ""
@export var level: int = 1
@export var experience: int = 0
@export var experience_to_next: int = 100

# Base Stats
@export var max_health: int = 100
@export var current_health: int = 100
@export var max_mana: int = 50
@export var current_mana: int = 50
@export var strength: int = 10
@export var dexterity: int = 10
@export var constitution: int = 10
@export var intelligence: int = 10
@export var wisdom: int = 10
@export var charisma: int = 10

# Derived Stats
@export var attack_power: int = 10
@export var defense: int = 10
@export var magic_power: int = 10
@export var magic_resistance: int = 10
@export var critical_chance: float = 0.05
@export var critical_multiplier: float = 1.5
@export var movement_speed: float = 5.0
@export var attack_speed: float = 1.0

# Skill Tree
var skill_tree: SkillTree = null
var unlocked_skills: Array[String] = []

func _init():
	# Initialize skill tree after character_class is set
	# This will be called after the character is created
	pass

func initialize_skill_tree():
	if skill_tree == null:
		skill_tree = SkillTree.new()
		skill_tree.setup_for_class(character_class)
		
func level_up():
	experience -= experience_to_next
	level += 1
	experience_to_next = calculate_experience_requirement(level)
	
	# Increase base stats on level up
	strength += get_stat_gain_per_level("strength")
	dexterity += get_stat_gain_per_level("dexterity")
	constitution += get_stat_gain_per_level("constitution")
	intelligence += get_stat_gain_per_level("intelligence")
	wisdom += get_stat_gain_per_level("wisdom")
	charisma += get_stat_gain_per_level("charisma")
	
	# Increase health and mana
	max_health += get_health_gain_per_level()
	max_mana += get_mana_gain_per_level()
	current_health = max_health
	current_mana = max_mana
	
	calculate_derived_stats()
	leveled_up.emit(level)


func add_experience(amount: int):
	experience += amount
	experience_gained.emit(amount)
	
	while experience >= experience_to_next and level < 100:
		level_up()

func calculate_experience_requirement(level):
	# Exponential growth: base * (1.1 ^ level)
	return int(100 * pow(1.1, level - 1))

func get_stat_gain_per_level(stat: String) -> int:
	match character_class:
		CharacterClass.FIGHTER:
			match stat:
				"strength": return 2
				"constitution": return 2
				_: return 1
		CharacterClass.WIZARD:
			match stat:
				"intelligence": return 3
				"wisdom": return 2
				_: return 0
		CharacterClass.ROGUE:
			match stat:
				"dexterity": return 3
				"strength": return 1
				_: return 1
		CharacterClass.CLERIC:
			match stat:
				"wisdom": return 3
				"constitution": return 1
				_: return 1
		CharacterClass.RANGER:
			match stat:
				"dexterity": return 2
				"wisdom": return 2
				_: return 1
	return 1

func get_health_gain_per_level() -> int:
	match character_class:
		CharacterClass.FIGHTER: return 15
		CharacterClass.WIZARD: return 5
		CharacterClass.ROGUE: return 8
		CharacterClass.CLERIC: return 10
		CharacterClass.RANGER: return 10
	return 10

func get_mana_gain_per_level() -> int:
	match character_class:
		CharacterClass.FIGHTER: return 3
		CharacterClass.WIZARD: return 15
		CharacterClass.ROGUE: return 5
		CharacterClass.CLERIC: return 12
		CharacterClass.RANGER: return 8
	return 5

func calculate_derived_stats():
	match character_class:
		CharacterClass.FIGHTER:
			attack_power = strength * 2 + level
			defense = constitution * 2 + level
			magic_power = intelligence + level / 2
			magic_resistance = wisdom + level / 2
		CharacterClass.WIZARD:
			attack_power = strength + level / 2
			defense = constitution + level / 2
			magic_power = intelligence * 3 + level
			magic_resistance = wisdom * 2 + level
		CharacterClass.ROGUE:
			attack_power = dexterity * 2 + strength + level
			defense = dexterity + constitution + level
			magic_power = intelligence + level / 2
			magic_resistance = wisdom + level / 2
			critical_chance = 0.1 + (dexterity * 0.01)
		CharacterClass.CLERIC:
			attack_power = strength + wisdom + level
			defense = constitution * 2 + level
			magic_power = wisdom * 3 + intelligence + level
			magic_resistance = wisdom * 2 + level
		CharacterClass.RANGER:
			attack_power = dexterity * 2 + level
			defense = dexterity + constitution + level
			magic_power = wisdom * 2 + level
			magic_resistance = wisdom * 2 + level

func unlock_skill(skill_id: String) -> bool:
	if skill_id in unlocked_skills:
		return false
	
	if skill_tree == null:
		initialize_skill_tree()
	
	var skill = skill_tree.get_skill(skill_id)
	if not skill:
		return false
	
	# Check prerequisites
	for prereq in skill.prerequisites:
		if prereq not in unlocked_skills:
			return false
	
	unlocked_skills.append(skill_id)
	apply_skill_effects(skill)
	skill_unlocked.emit(skill_id)
	return true

func apply_skill_effects(skill: Skill):
	match skill.effect_type:
		Skill.EffectType.STAT_BOOST:
			match skill.target_stat:
				"strength": strength += skill.effect_value
				"dexterity": dexterity += skill.effect_value
				"constitution": constitution += skill.effect_value
				"intelligence": intelligence += skill.effect_value
				"wisdom": wisdom += skill.effect_value
				"charisma": charisma += skill.effect_value
			calculate_derived_stats()
		Skill.EffectType.ABILITY_UNLOCK:
			# Unlock new ability
			pass
		Skill.EffectType.PASSIVE_EFFECT:
			# Apply passive effect
			pass

func take_damage(amount: int):
	current_health = max(0, current_health - amount)

func heal(amount: int):
	current_health = min(max_health, current_health + amount)

func use_mana(amount: int) -> bool:
	if current_mana >= amount:
		current_mana -= amount
		return true
	return false

func restore_mana(amount: int):
	current_mana = min(max_mana, current_mana + amount)

func is_alive() -> bool:
	return current_health > 0
