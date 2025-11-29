extends Control
class_name HUD

## Main HUD for in-game UI

@onready var health_bar = $TopBar/HealthBar
@onready var mana_bar = $TopBar/ManaBar
@onready var level_label = $TopBar/LevelLabel
@onready var exp_bar = $TopBar/ExpBar
@onready var skill_tree_button = $BottomBar/SkillTreeButton

var player: Player = null

func _ready():
	if skill_tree_button:
		skill_tree_button.pressed.connect(_on_skill_tree_pressed)

func setup(player_instance: Player):
	player = player_instance
	if player and player.character:
		if player.character.has_signal("leveled_up"):
			player.character.leveled_up.connect(_on_level_up)
		if player.character.has_signal("experience_gained"):
			player.character.experience_gained.connect(_on_experience_gained)

func _process(_delta):
	if player and player.character:
		update_display()

func update_display():
	if not player or not player.character:
		return
	
	var char = player.character
	if health_bar:
		health_bar.value = (char.current_health / float(char.max_health)) * 100
	if mana_bar:
		mana_bar.value = (char.current_mana / float(char.max_mana)) * 100
	if level_label:
		level_label.text = "Level " + str(char.level)
	
	if exp_bar:
		var exp_percent = (char.experience / float(char.experience_to_next)) * 100
		exp_bar.value = exp_percent

func _on_level_up(new_level: int):
	# Show level up notification
	print("Level Up! Now level ", new_level)

func _on_experience_gained(amount: int):
	# Show exp gain notification
	pass

func _on_skill_tree_pressed():
	# Open skill tree UI
	var skill_tree_ui = preload("res://scenes/ui/SkillTreeUI.tscn").instantiate()
	add_child(skill_tree_ui)
	if player and player.character:
		skill_tree_ui.setup(player.character)
