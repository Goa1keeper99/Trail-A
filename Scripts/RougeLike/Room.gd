extends Node3D
class_name Room

## Individual room in the roguelike dungeon

@export var room_type: RoomType = RoomType.COMBAT
@export var is_cleared: bool = false
@export var enemy_count: int = 0

enum RoomType {
	COMBAT,
	TREASURE,
	BOSS,
	SHOP,
	REST
}

var enemies: Array[Enemy] = []
var connections: Array[Room] = []

func _ready():
	if room_type == RoomType.COMBAT:
		spawn_enemies()

func spawn_enemies():
	# Spawn enemies based on difficulty
	var difficulty = 1
	if GameManager and GameManager.current_run and GameManager.current_run.character:
		difficulty = GameManager.current_run.character.level
	enemy_count = randi_range(3, 5 + difficulty / 10)
	
	for i in range(enemy_count):
		var enemy_scene = preload("res://scenes/Enemy.tscn")
		var enemy = enemy_scene.instantiate()
		var spawn_pos = global_position + Vector3(
			randf_range(-5, 5),
			0,
			randf_range(-5, 5)
		)
		enemy.global_position = spawn_pos
		var scene = get_tree().current_scene
		if scene:
			scene.add_child(enemy)
		enemies.append(enemy)

func check_clear():
	if room_type == RoomType.COMBAT:
		for enemy in enemies:
			if is_instance_valid(enemy):
				return false
		is_cleared = true
		if GameManager and GameManager.current_run:
			GameManager.current_run.rooms_cleared += 1
		return true
	return false
