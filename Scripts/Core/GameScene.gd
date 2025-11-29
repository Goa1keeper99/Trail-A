extends Node3D

## Main game scene controller

@onready var world = $World
@onready var hud = $UI/HUD

var dungeon_generator: DungeonGenerator
var current_rooms: Array[Room] = []
var player: Player = null

func _ready():
	dungeon_generator = DungeonGenerator.new()
	generate_dungeon()
	spawn_player()

func generate_dungeon():
	current_rooms = dungeon_generator.generate_dungeon()
	
	# Spawn room meshes with proper materials
	for room in current_rooms:
		world.add_child(room)
		
		# Create floor
		var floor_mesh = MeshInstance3D.new()
		var box_mesh = BoxMesh.new()
		box_mesh.size = Vector3(20, 0.2, 20)
		floor_mesh.mesh = box_mesh
		floor_mesh.position = Vector3(0, 0, 0)
		var ground_mat = MaterialManager.get_ground_material()
		if ground_mat:
			floor_mesh.set_surface_override_material(0, ground_mat)
		room.add_child(floor_mesh)
		
		# Create walls
		var wall_mat = MaterialManager.get_wall_material()
		for i in range(4):
			var wall_mesh = MeshInstance3D.new()
			var wall_box = BoxMesh.new()
			wall_box.size = Vector3(20, 5, 0.5)
			wall_mesh.mesh = wall_box
			
			match i:
				0: 
						wall_mesh.position = Vector3(0, 2.5, -10)
				1: 
					
						wall_mesh.position = Vector3(0, 2.5, 10)
				2: 
						wall_mesh.position = Vector3(-10, 2.5, 0)
						wall_mesh.rotation_degrees.y = 90
				3: 
						wall_mesh.position = Vector3(10, 2.5, 0)
						wall_mesh.rotation_degrees.y = 90
			
			if wall_mat:
				wall_mesh.set_surface_override_material(0, wall_mat)
			room.add_child(wall_mesh)

func spawn_player():
	if GameManager and GameManager.current_run and GameManager.current_run.character:
		var player_scene = preload("res://scenes/Player.tscn")
		player = player_scene.instantiate()
		player.setup(1, GameManager.current_run.character, true)
		player.position = Vector3.ZERO
		add_child(player)
		
		if hud:
			hud.setup(player)
	else:
		print("Warning: Cannot spawn player - no character selected")
