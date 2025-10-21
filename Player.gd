extends CharacterBody2D
class_name Player

# Signals
signal stress_changed(new_stress)
signal syringe_count_changed(count)
signal transformation_started
signal transformation_ended
signal game_over

# States
enum State {
	NORMAL,
	TRANSFORMING,
	SWOLE,
	COOLING_DOWN
}

# Movement
@export var normal_speed: float = 200.0
@export var swole_speed: float = 300.0

# Stats
@export var max_stress: float = 100.0
var current_stress: float = 0.0
var syringe_count: int = 0
var power_xp: int = 0

# State management
var current_state: State = State.NORMAL
var transformation_timer: float = 0.0
var swole_duration: float = 10.0  # seconds in swole mode
var transformation_duration: float = 1.0  # seconds to transform
var cooldown_duration: float = 1.0  # seconds to cool down

# Visual
var base_scale: Vector2 = Vector2.ONE
var swole_scale: Vector2 = Vector2(2.0, 2.0)
var current_muscle_scale: float = 1.0

# Side effects tracking
var total_syringe_uses: int = 0
var hallucination_threshold: int = 5

# Node references
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	add_to_group("player")
	update_visual_state()

func _physics_process(delta):
	handle_movement(delta)
	update_state(delta)
	update_visual_state()
	move_and_slide()

func handle_movement(_delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	
	input_vector = input_vector.normalized()
	
	var current_speed = swole_speed if current_state == State.SWOLE else normal_speed
	velocity = input_vector * current_speed

func update_state(delta):
	match current_state:
		State.TRANSFORMING:
			transformation_timer += delta
			current_muscle_scale = 1.0 + (transformation_timer / transformation_duration)
			
			if transformation_timer >= transformation_duration:
				enter_swole_state()
				
		State.SWOLE:
			transformation_timer += delta
			
			if transformation_timer >= swole_duration:
				enter_cooldown_state()
				
		State.COOLING_DOWN:
			transformation_timer += delta
			var progress = transformation_timer / cooldown_duration
			current_muscle_scale = lerpf(2.0, 1.0, progress)
			
			if transformation_timer >= cooldown_duration:
				enter_normal_state()

func update_visual_state():
	if sprite:
		sprite.scale = base_scale * current_muscle_scale
		
		# Change color based on state
		match current_state:
			State.NORMAL:
				sprite.modulate = Color.WHITE
			State.TRANSFORMING:
				sprite.modulate = Color.YELLOW
			State.SWOLE:
				sprite.modulate = Color.RED
			State.COOLING_DOWN:
				sprite.modulate = Color.ORANGE

func use_syringe():
	if syringe_count > 0 and current_state == State.NORMAL:
		syringe_count -= 1
		total_syringe_uses += 1
		syringe_count_changed.emit(syringe_count)
		enter_transforming_state()
		return true
	return false

func enter_transforming_state():
	current_state = State.TRANSFORMING
	transformation_timer = 0.0
	transformation_started.emit()
	
	# Trigger gym minigame through signal
	get_tree().call_group("game_manager", "start_gym_minigame")

func enter_swole_state():
	current_state = State.SWOLE
	transformation_timer = 0.0
	current_muscle_scale = 2.0

func enter_cooldown_state():
	current_state = State.COOLING_DOWN
	transformation_timer = 0.0

func enter_normal_state():
	current_state = State.NORMAL
	current_muscle_scale = 1.0
	transformation_ended.emit()

func add_stress(amount: float):
	current_stress = clamp(current_stress + amount, 0, max_stress)
	stress_changed.emit(current_stress)
	
	if current_stress >= max_stress:
		game_over.emit()

func reduce_stress(amount: float):
	add_stress(-amount)

func add_syringe():
	syringe_count += 1
	syringe_count_changed.emit(syringe_count)

func add_power_xp(amount: int):
	power_xp += amount

func is_swole() -> bool:
	return current_state == State.SWOLE

func get_stress_percent() -> float:
	return current_stress / max_stress

func check_hallucination() -> bool:
	return total_syringe_uses >= hallucination_threshold
