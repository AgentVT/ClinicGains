extends Area2D
class_name Emergency

signal resolved(emergency)
signal failed(emergency)

@export var max_timer: float = 10.0  # seconds before failure
@export var resolution_radius: float = 100.0

var emergency_type: String = "Emergency"
var timer: float = 0.0
var active: bool = true
var flash_timer: float = 0.0

# Node references
@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	add_to_group("emergencies")
	
	if label:
		label.text = emergency_type
	
	if progress_bar:
		progress_bar.max_value = max_timer
		progress_bar.value = max_timer
	
	# Connect area signals
	body_entered.connect(_on_body_entered)

func _process(delta):
	if not active:
		return
	
	timer += delta
	flash_timer += delta
	
	# Update progress bar
	if progress_bar:
		progress_bar.value = max_timer - timer
	
	# Flash effect
	if sprite:
		var flash = sin(flash_timer * 10.0) * 0.3 + 0.7
		sprite.modulate = Color(1.0, flash, flash)
	
	# Check if time ran out
	if timer >= max_timer:
		fail_emergency()

func _on_body_entered(body):
	if body is Player and body.is_swole() and active:
		resolve_emergency()

func resolve_emergency():
	if not active:
		return
	
	active = false
	resolved.emit(self)
	
	# Visual feedback
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	tween.tween_callback(queue_free)

func fail_emergency():
	if not active:
		return
	
	active = false
	failed.emit(self)
	
	# Visual feedback
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)

func get_time_remaining() -> float:
	return max_timer - timer

func get_progress() -> float:
	return 1.0 - (timer / max_timer)
