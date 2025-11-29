extends Node

## Main game manager that handles game state, runs, and progression

signal run_started
signal run_ended(completed: bool)
signal level_up(character_class: String, new_level: int)

enum GameState {
	MENU,
	CHARACTER_SELECT,
	IN_RUN,
	PAUSED,
	GAME_OVER
}

var current_state: GameState = GameState.MENU
var current_run: RunData = null
var player_data: Dictionary = {}

func _ready():
	load_player_data()

func start_new_run(character_class: String):
	var character = CharacterFactory.create_character(character_class)
	current_run = RunData.new()
	current_run.character = character
	current_run.start_time = Time.get_ticks_msec()
	current_state = GameState.IN_RUN
	run_started.emit()
	
func end_run(completed: bool = false):
	if current_run:
		if completed:
			# Award experience and resources
			var exp_gained = calculate_experience_reward()
			current_run.character.add_experience(exp_gained)
			save_player_data()
		current_run = null
	current_state = GameState.MENU
	run_ended.emit(completed)

func calculate_experience_reward() -> int:
	if not current_run:
		return 0
	# Base exp + bonuses based on run performance
	var base_exp = 100
	var time_bonus = max(0, 300 - (Time.get_ticks_msec() - current_run.start_time) / 1000)
	return base_exp + time_bonus

func load_player_data():
	# Load from file or create new
	if FileAccess.file_exists("user://player_data.save"):
		var file = FileAccess.open("user://player_data.save", FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()
		var json = JSON.new()
		json.parse(json_string)
		player_data = json.data
	else:
		player_data = {
			"characters": {},
			"unlocked_classes": ["Fighter"],
			"total_runs": 0,
			"total_wins": 0
		}

func save_player_data():
	var file = FileAccess.open("user://player_data.save", FileAccess.WRITE)
	var json_string = JSON.stringify(player_data)
	file.store_string(json_string)
	file.close()

class RunData:
	var character: Character = null
	var start_time: int = 0
	var enemies_killed: int = 0
	var rooms_cleared: int = 0
	var items_collected: int = 0
