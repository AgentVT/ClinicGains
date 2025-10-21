extends Node
class_name GameManager

# Game states
enum GameState {
	CLINIC,
	GYM_MINIGAME,
	GAME_OVER,
	PAUSED
}

# Emergency types
const EMERGENCY_TYPES = [
	"Code Blue",
	"Fire Alarm",
	"Patient Panic",
	"System Failure",
	"Angry Visitor"
]

# Spawn settings
@export var emergency_spawn_interval: float = 8.0  # seconds
@export var syringe_spawn_interval: float = 15.0  # seconds
@export var stress_increase_rate: float = 2.0  # per second during emergencies
@export var max_active_emergencies: int = 3

# Scene references
@export var emergency_scene: PackedScene
@export var syringe_scene: PackedScene

# State
var current_state: GameState = GameState.CLINIC
var emergency_timer: float = 0.0
var syringe_timer: float = 0.0
var active_emergencies: Array = []

# Node references
var player: Player
var gym_minigame: Control
var ui: Control
var spawn_area: Rect2 = Rect2(100, 100, 800, 500)  # Will be set from level

func _ready():
	add_to_group("game_manager")
	
	# Find player
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		player.game_over.connect(_on_player_game_over)
		player.transformation_started.connect(_on_transformation_started)
	
	# Find UI
	ui = get_tree().get_first_node_in_group("game_ui")
	
	# Find gym minigame
	gym_minigame = get_tree().get_first_node_in_group("gym_minigame")
	if gym_minigame:
		gym_minigame.hide()
		gym_minigame.minigame_completed.connect(_on_minigame_completed)
	
	# Spawn initial syringe
	spawn_syringe()

func _process(delta):
	if current_state == GameState.CLINIC:
		handle_clinic_phase(delta)
	
	# Input handling
	if Input.is_action_just_pressed("use_syringe"):
		if player and current_state == GameState.CLINIC:
			player.use_syringe()
	
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func handle_clinic_phase(delta):
	# Emergency spawning
	emergency_timer += delta
	if emergency_timer >= emergency_spawn_interval and active_emergencies.size() < max_active_emergencies:
		spawn_emergency()
		emergency_timer = 0.0
	
	# Syringe spawning
	syringe_timer += delta
	if syringe_timer >= syringe_spawn_interval:
		spawn_syringe()
		syringe_timer = 0.0
	
	# Passive stress increase when emergencies are active
	if active_emergencies.size() > 0 and player:
		player.add_stress(stress_increase_rate * delta * active_emergencies.size())

func spawn_emergency():
	if not emergency_scene:
		return
	
	var emergency = emergency_scene.instantiate()
	var spawn_pos = get_random_spawn_position()
	emergency.position = spawn_pos
	emergency.emergency_type = EMERGENCY_TYPES[randi() % EMERGENCY_TYPES.size()]
	
	# Connect signals
	emergency.resolved.connect(_on_emergency_resolved)
	emergency.failed.connect(_on_emergency_failed)
	
	get_tree().current_scene.add_child(emergency)
	active_emergencies.append(emergency)

func spawn_syringe():
	if not syringe_scene:
		return
	
	var syringe = syringe_scene.instantiate()
	var spawn_pos = get_random_spawn_position()
	syringe.position = spawn_pos
	
	syringe.picked_up.connect(_on_syringe_picked_up)
	
	get_tree().current_scene.add_child(syringe)

func get_random_spawn_position() -> Vector2:
	return Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)

func start_gym_minigame():
	if gym_minigame and current_state == GameState.CLINIC:
		current_state = GameState.GYM_MINIGAME
		gym_minigame.show()
		gym_minigame.start_minigame()
		get_tree().paused = true  # Pause clinic activity

func _on_minigame_completed(score: int):
	current_state = GameState.CLINIC
	gym_minigame.hide()
	get_tree().paused = false
	
	if player:
		player.add_power_xp(score)
		player.enter_swole_state()

func _on_emergency_resolved(emergency):
	active_emergencies.erase(emergency)
	if player:
		player.reduce_stress(15.0)
		player.add_power_xp(10)

func _on_emergency_failed(emergency):
	active_emergencies.erase(emergency)
	if player:
		player.add_stress(25.0)

func _on_syringe_picked_up():
	if player:
		player.add_syringe()

func _on_transformation_started():
	# Could add screen effects, sound, etc.
	pass

func _on_player_game_over():
	current_state = GameState.GAME_OVER
	if ui:
		ui.show_game_over()

func toggle_pause():
	if current_state == GameState.PAUSED:
		current_state = GameState.CLINIC
		get_tree().paused = false
	elif current_state == GameState.CLINIC:
		current_state = GameState.PAUSED
		get_tree().paused = true

func set_spawn_area(area: Rect2):
	spawn_area = area
