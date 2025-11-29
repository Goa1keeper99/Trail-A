extends Node
class_name DungeonGenerator

## Generates procedural roguelike dungeons

@export var room_count: int = 10
@export var room_size: Vector2 = Vector2(20, 20)

var rooms: Array[Room] = []
var room_positions: Dictionary = {}
var room_pos_map: Dictionary = {}  # Maps room to its Vector2 position

func generate_dungeon() -> Array[Room]:
	rooms.clear()
	room_positions.clear()
	room_pos_map.clear()
	
	# Create starting room
	var start_room = create_room(Room.RoomType.REST, Vector2.ZERO)
	rooms.append(start_room)
	room_positions[Vector2.ZERO] = start_room
	room_pos_map[start_room] = Vector2.ZERO
	
	# Generate rooms
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	
	for i in range(room_count - 1):
		var attempts = 0
		var placed = false
		
		while not placed and attempts < 100:
			var random_room = rooms[randi() % rooms.size()]
			var random_dir = directions[randi() % directions.size()]
			var room_pos_2d = room_pos_map[random_room]
			var new_pos = room_pos_2d + random_dir * room_size
			
			if not room_positions.has(new_pos):
				var room_type = Room.RoomType.COMBAT
				if i == room_count - 2:
					room_type = Room.RoomType.BOSS
				elif randf() < 0.1:
					room_type = Room.RoomType.TREASURE
				elif randf() < 0.1:
					room_type = Room.RoomType.SHOP
				
				var new_room = create_room(room_type, new_pos)
				rooms.append(new_room)
				room_positions[new_pos] = new_room
				room_pos_map[new_room] = new_pos
				
				# Connect rooms
				random_room.connections.append(new_room)
				new_room.connections.append(random_room)
				
				placed = true
			attempts += 1
	
	return rooms

func create_room(type: Room.RoomType, position: Vector2) -> Room:
	var room = Room.new()
	room.room_type = type
	room.position = Vector3(position.x, 0, position.y)
	return room
