extends Resource
class_name SkillTree

## Skill tree system for character progression

# Character class enum values (to avoid circular dependency)
enum CharacterClass {
	FIGHTER = 0,
	WIZARD = 1,
	ROGUE = 2,
	CLERIC = 3,
	RANGER = 4
}

var skills: Dictionary = {}
var skill_nodes: Array[SkillNode] = []

func setup_for_class(character_class):
	skills.clear()
	skill_nodes.clear()
	
	# Use int comparison to avoid circular dependency
	var class_int = character_class as int
	match class_int:
		CharacterClass.FIGHTER:
			setup_fighter_tree()
		CharacterClass.WIZARD:
			setup_wizard_tree()
		CharacterClass.ROGUE:
			setup_rogue_tree()
		CharacterClass.CLERIC:
			setup_cleric_tree()
		CharacterClass.RANGER:
			setup_ranger_tree()

func get_skill(skill_id: String) -> Skill:
	return skills.get(skill_id)

func setup_fighter_tree():
	# Tier 1 - Basic Skills
	add_skill("fighter_weapon_mastery", "Weapon Mastery", "Increases attack power by 10%", 1, [], Skill.EffectType.STAT_BOOST, "strength", 2)
	add_skill("fighter_armor_training", "Armor Training", "Increases defense by 10%", 1, [], Skill.EffectType.STAT_BOOST, "constitution", 2)
	add_skill("fighter_second_wind", "Second Wind", "Restore 25% health once per combat", 1, [], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	
	# Tier 2 - Intermediate
	add_skill("fighter_berserker_rage", "Berserker Rage", "Increases damage by 25% when below 50% health", 2, ["fighter_weapon_mastery"], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	add_skill("fighter_shield_master", "Shield Master", "Block reduces damage by 50%", 2, ["fighter_armor_training"], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	add_skill("fighter_charge", "Charge", "Rush forward and stun enemies", 2, ["fighter_second_wind"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	
	# Tier 3 - Advanced
	add_skill("fighter_whirlwind", "Whirlwind", "Spin attack hitting all nearby enemies", 3, ["fighter_berserker_rage"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("fighter_iron_will", "Iron Will", "Immune to crowd control effects", 3, ["fighter_shield_master"], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	add_skill("fighter_war_cry", "War Cry", "Taunt enemies and boost party damage", 3, ["fighter_charge"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	
	# Tier 4 - Master
	add_skill("fighter_unstoppable", "Unstoppable", "Cannot be killed while above 10% health for 5 seconds", 4, ["fighter_whirlwind", "fighter_iron_will"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("fighter_legendary_strength", "Legendary Strength", "Strength increased by 50%", 4, ["fighter_unstoppable"], Skill.EffectType.STAT_BOOST, "strength", 10)

func setup_wizard_tree():
	# Tier 1
	add_skill("wizard_arcane_focus", "Arcane Focus", "Increases magic power by 15%", 1, [], Skill.EffectType.STAT_BOOST, "intelligence", 3)
	add_skill("wizard_mana_efficiency", "Mana Efficiency", "Reduces mana costs by 20%", 1, [], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	add_skill("wizard_fireball", "Fireball", "Launch explosive fire projectile", 1, [], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	
	# Tier 2
	add_skill("wizard_ice_bolt", "Ice Bolt", "Freeze enemies with ice magic", 2, ["wizard_fireball"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("wizard_arcane_shield", "Arcane Shield", "Absorb damage with mana", 2, ["wizard_mana_efficiency"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("wizard_spell_mastery", "Spell Mastery", "All spells deal 25% more damage", 2, ["wizard_arcane_focus"], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	
	# Tier 3
	add_skill("wizard_meteor", "Meteor", "Summon meteor from sky", 3, ["wizard_ice_bolt", "wizard_spell_mastery"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("wizard_teleport", "Teleport", "Instantly move to target location", 3, ["wizard_arcane_shield"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("wizard_chain_lightning", "Chain Lightning", "Lightning jumps between enemies", 3, ["wizard_spell_mastery"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	
	# Tier 4
	add_skill("wizard_archmage", "Archmage", "All spells have no cooldown for 10 seconds", 4, ["wizard_meteor", "wizard_chain_lightning"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("wizard_ultimate_power", "Ultimate Power", "Intelligence increased by 50%", 4, ["wizard_archmage"], Skill.EffectType.STAT_BOOST, "intelligence", 15)

func setup_rogue_tree():
	# Tier 1
	add_skill("rogue_sneak_attack", "Sneak Attack", "Deal 200% damage from behind", 1, [], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	add_skill("rogue_dual_wield", "Dual Wield", "Attack twice per swing", 1, [], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	add_skill("rogue_backstab", "Backstab", "Teleport behind enemy and strike", 1, [], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	
	# Tier 2
	add_skill("rogue_poison_blade", "Poison Blade", "Attacks apply poison damage over time", 2, ["rogue_sneak_attack"], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	add_skill("rogue_shadow_step", "Shadow Step", "Become invisible for 3 seconds", 2, ["rogue_backstab"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("rogue_critical_mastery", "Critical Mastery", "Critical chance increased by 25%", 2, ["rogue_dual_wield"], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	
	# Tier 3
	add_skill("rogue_blade_dance", "Blade Dance", "Rapidly attack all nearby enemies", 3, ["rogue_poison_blade", "rogue_critical_mastery"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("rogue_assassinate", "Assassinate", "Instant kill on enemies below 30% health", 3, ["rogue_shadow_step"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("rogue_evasion", "Evasion", "50% chance to dodge attacks", 3, ["rogue_critical_mastery"], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	
	# Tier 4
	add_skill("rogue_death_mark", "Death Mark", "Marked enemies take 100% more damage", 4, ["rogue_blade_dance", "rogue_assassinate"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("rogue_perfect_strike", "Perfect Strike", "Dexterity increased by 50%", 4, ["rogue_death_mark"], Skill.EffectType.STAT_BOOST, "dexterity", 12)

func setup_cleric_tree():
	# Tier 1
	add_skill("cleric_heal", "Heal", "Restore health to self or ally", 1, [], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("cleric_divine_smite", "Divine Smite", "Deal holy damage to enemies", 1, [], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("cleric_blessing", "Blessing", "Increase all stats by 10%", 1, [], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	
	# Tier 2
	add_skill("cleric_resurrection", "Resurrection", "Revive fallen ally", 2, ["cleric_heal"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("cleric_turn_undead", "Turn Undead", "Damage and stun undead enemies", 2, ["cleric_divine_smite"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("cleric_divine_protection", "Divine Protection", "Reduce all damage by 30%", 2, ["cleric_blessing"], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	
	# Tier 3
	add_skill("cleric_aura_of_life", "Aura of Life", "Heal nearby allies over time", 3, ["cleric_resurrection"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("cleric_holy_fire", "Holy Fire", "Burning aura damages nearby enemies", 3, ["cleric_turn_undead"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("cleric_divine_intervention", "Divine Intervention", "Become invulnerable for 5 seconds", 3, ["cleric_divine_protection"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	
	# Tier 4
	add_skill("cleric_avatar", "Avatar", "Transform into divine form with increased power", 4, ["cleric_aura_of_life", "cleric_holy_fire"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("cleric_divine_essence", "Divine Essence", "Wisdom increased by 50%", 4, ["cleric_avatar"], Skill.EffectType.STAT_BOOST, "wisdom", 12)

func setup_ranger_tree():
	# Tier 1
	add_skill("ranger_precise_shot", "Precise Shot", "Ranged attacks deal 25% more damage", 1, [], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	add_skill("ranger_animal_companion", "Animal Companion", "Summon wolf companion", 1, [], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("ranger_trap", "Trap", "Place trap that damages enemies", 1, [], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	
	# Tier 2
	add_skill("ranger_multishot", "Multishot", "Fire 3 arrows at once", 2, ["ranger_precise_shot"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("ranger_beast_mastery", "Beast Mastery", "Companion deals 50% more damage", 2, ["ranger_animal_companion"], Skill.EffectType.PASSIVE_EFFECT, "", 0)
	add_skill("ranger_camouflage", "Camouflage", "Become invisible while stationary", 2, ["ranger_trap"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	
	# Tier 3
	add_skill("ranger_rain_of_arrows", "Rain of Arrows", "Arrow storm damages area", 3, ["ranger_multishot"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("ranger_pack_leader", "Pack Leader", "Summon 2 additional companions", 3, ["ranger_beast_mastery"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("ranger_hunters_mark", "Hunter's Mark", "Marked enemies take increased damage", 3, ["ranger_camouflage"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	
	# Tier 4
	add_skill("ranger_world_arrow", "World Arrow", "Pierce through all enemies in line", 4, ["ranger_rain_of_arrows", "ranger_hunters_mark"], Skill.EffectType.ABILITY_UNLOCK, "", 0)
	add_skill("ranger_nature_master", "Nature Master", "Dexterity and Wisdom increased by 50%", 4, ["ranger_world_arrow"], Skill.EffectType.STAT_BOOST, "dexterity", 10)

func add_skill(id: String, name: String, description: String, tier: int, prerequisites: Array, effect_type: Skill.EffectType, target_stat: String, effect_value: int):
	var skill = Skill.new()
	skill.id = id
	skill.name = name
	skill.description = description
	skill.tier = tier
	skill.prerequisites = prerequisites
	skill.effect_type = effect_type
	skill.target_stat = target_stat
	skill.effect_value = effect_value
	skills[id] = skill

class SkillNode:
	var skill: Skill
	var position: Vector2
	var connections: Array[String] = []
