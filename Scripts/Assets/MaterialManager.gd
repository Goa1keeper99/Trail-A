extends Node

## Manages materials for different character classes and entities

const MATERIALS = {
	"fighter": preload("res://assets/materials/fighter_material.tres"),
	"wizard": preload("res://assets/materials/wizard_material.tres"),
	"rogue": preload("res://assets/materials/rogue_material.tres"),
	"cleric": preload("res://assets/materials/cleric_material.tres"),
	"ranger": preload("res://assets/materials/ranger_material.tres"),
	"enemy": preload("res://assets/materials/enemy_material.tres"),
	"ground": preload("res://assets/materials/ground_material.tres"),
	"wall": preload("res://assets/materials/wall_material.tres")
}

static func get_material_for_class(character_class: String) -> Material:
	var class_lower = character_class.to_lower()
	if MATERIALS.has(class_lower):
		return MATERIALS[class_lower]
	return MATERIALS["fighter"]

static func get_enemy_material() -> Material:
	return MATERIALS["enemy"]

static func get_ground_material() -> Material:
	return MATERIALS["ground"]

static func get_wall_material() -> Material:
	return MATERIALS["wall"]

