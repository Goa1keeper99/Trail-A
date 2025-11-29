extends CharacterBody3D
class_name Player

## Player controller with movement, combat, and multiplayer sync

@export var player_id: int = 1
@export var is_local: bool = false
@export var character: Character = null

@onready var camera_pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D
@onready var mesh_instance = $MeshInstance3D
@onready var health_bar = $UI/HealthBar
@onready var mana_bar = $UI/ManaBar

var move_speed: float = 5.0
var jump_velocity: float = 4.5
var mouse_sensitivity: float = 0.003
var gravity: float = 9.8

var input_dir: Vector2
var mouse_delta: Vector2

func _ready():
	if not is_local:
		if camera:
			camera.current = false
		set_process_input(false)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		update_ui()

func setup(id: int, char: Character, local: bool):
	player_id = id
	character = char
	is_local = local
	if character:
		move_speed = character.movement_speed
		set_multiplayer_authority(id)
		apply_character_visuals()

func _input(event):
	if not is_local:
		return
	
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

func _physics_process(delta):
	if not is_local:
		return
	
	# Handle gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get input direction
	input_dir = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
	
	# Handle mouse look
	if mouse_delta.length() > 0 and camera_pivot:
		rotate_y(-mouse_delta.x * mouse_sensitivity)
		camera_pivot.rotate_x(-mouse_delta.y * mouse_sensitivity)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		mouse_delta = Vector2.ZERO
	
	# Handle combat
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_pressed("block"):
		block()
	
	# Handle abilities
	if Input.is_action_just_pressed("use_ability_1"):
		use_ability(1)
	if Input.is_action_just_pressed("use_ability_2"):
		use_ability(2)
	if Input.is_action_just_pressed("use_ability_3"):
		use_ability(3)
	
	move_and_slide()
	update_ui()
	if multiplayer.has_multiplayer_peer() and not multiplayer.is_server():
		# Client syncs to server
		sync_to_server.rpc_id(1, global_position, rotation)

@rpc("any_peer", "call_local", "unreliable")
func sync_to_server(pos: Vector3, rot: float):
	if is_multiplayer_authority():
		global_position = pos
		rotation.y = rot

func attack():
	if not character or not camera:
		return
	
	# Simple melee attack
	var space_state = get_world_3d().direct_space_state
	if not space_state:
		return
	var query = PhysicsRayQueryParameters3D.create(camera.global_position, camera.global_position + camera.global_transform.basis.z * -2.0)
	query.collision_mask = 2  # Enemy layer
	var result = space_state.intersect_ray(query)
	
	if result:
		var enemy = result.collider
		if enemy and enemy.has_method("take_damage"):
			var damage = character.attack_power
			if randf() < character.critical_chance:
				damage = int(damage * character.critical_multiplier)
			enemy.take_damage(damage)

func block():
	# Block reduces incoming damage
	pass

func use_ability(ability_slot: int):
	if not character:
		return
	
	# Get ability from character's unlocked skills
	# This is a placeholder - implement based on skill system
	pass

func take_damage(amount: int):
	if not character:
		return
	
	character.take_damage(amount)
	if not character.is_alive():
		die()

func die():
	# Handle player death
	GameManager.end_run(false)

func apply_character_visuals():
	if not character:
		return
	
	var body_mesh = get_node_or_null("Body/MeshInstance3D")
	if body_mesh:
		var material = MaterialManager.get_material_for_class(character.character_name)
		if material:
			body_mesh.set_surface_override_material(0, material)

func update_ui():
	if not character:
		return
	
	if health_bar:
		health_bar.value = (character.current_health / float(character.max_health)) * 100
	if mana_bar:
		mana_bar.value = (character.current_mana / float(character.max_mana)) * 100
