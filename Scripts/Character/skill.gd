extends Resource
class_name Skill

## Individual skill definition

enum EffectType {
	STAT_BOOST,
	ABILITY_UNLOCK,
	PASSIVE_EFFECT
}

@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var tier: int = 1
@export var prerequisites: Array[String] = []
@export var effect_type: EffectType = EffectType.STAT_BOOST
@export var target_stat: String = ""
@export var effect_value: int = 0
@export var cooldown: float = 0.0
@export var mana_cost: int = 0
