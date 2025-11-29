extends CharacterBody3D
class_name Enemy

## Base enemy class with AI and combat

@export var enemy_type: String = "goblin"
@export var max_health: int = 50
@export var attack_damage: int = 10
@export var move_speed: float = 3.0
@export var attack_range: float = 2.0
@export var detection_range: float = 10.0

var current_health: int
var target: Node3D = null
var state: EnemyState = EnemyState.IDLE
var attack_cooldown: float = 0.0

enum EnemyState {
	IDLE,
	CHASING,
	ATTACKING,
	STUNNED
}

@onready var detection_area = $DetectionArea
@onready var attack_area = $AttackArea

func _ready():
	current_health = max_health
	detection_area.body_entered.connect(_on_player_detected)
	detection_area.body_exited.connect(_on_player_lost)

func _physics_process(delta):
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	match state:
		EnemyState.IDLE:
			idle_behavior(delta)
		EnemyState.CHASING:
			chase_behavior(delta)
		EnemyState.ATTACKING:
			attack_behavior(delta)

func idle_behavior(delta):
	# Wander or patrol
	pass

func chase_behavior(delta):
	if not target:
		state = EnemyState.IDLE
		return
	
	var direction = (target.global_position - global_position).normalized()
	direction.y = 0
	
	var distance = global_position.distance_to(target.global_position)
	
	if distance <= attack_range:
		state = EnemyState.ATTACKING
	else:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		look_at(target.global_position, Vector3.UP)
		move_and_slide()

func attack_behavior(delta):
	if not target:
		state = EnemyState.IDLE
		return
	
	var distance = global_position.distance_to(target.global_position)
	
	if distance > attack_range:
		state = EnemyState.CHASING
		return
	
	if attack_cooldown <= 0:
		perform_attack()
		attack_cooldown = 1.5

func perform_attack():
	if target and target.has_method("take_damage"):
		target.take_damage(attack_damage)

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	# Drop loot, award experience
	if GameManager and GameManager.current_run:
		GameManager.current_run.enemies_killed += 1
	queue_free()

func _on_player_detected(body):
	if body is Player:
		target = body
		state = EnemyState.CHASING

func _on_player_lost(body):
	if body == target:
		target = null
		state = EnemyState.IDLE
