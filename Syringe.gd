extends Area2D
class_name Syringe

signal picked_up

@export var bob_speed: float = 2.0
@export var bob_amount: float = 10.0

var initial_y: float = 0.0
var time_passed: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	initial_y = position.y
	body_entered.connect(_on_body_entered)
	
	# Spawn animation
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _process(delta):
	# Bobbing animation
	time_passed += delta
	position.y = initial_y + sin(time_passed * bob_speed) * bob_amount
	
	# Rotate
	if sprite:
		sprite.rotation += delta * 2.0

func _on_body_entered(body):
	if body is Player:
		pickup()

func pickup():
	picked_up.emit()
	
	# Pickup animation
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2(2.0, 2.0), 0.2)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)
