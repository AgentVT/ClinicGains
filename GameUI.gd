extends CanvasLayer
class_name GameUI

# Node references
@onready var stress_bar: ProgressBar = $MarginContainer/VBoxContainer/StressBar
@onready var stress_label: Label = $MarginContainer/VBoxContainer/StressLabel
@onready var syringe_label: Label = $MarginContainer/VBoxContainer/SyringeLabel
@onready var power_xp_label: Label = $MarginContainer/VBoxContainer/PowerXPLabel
@onready var controls_label: Label = $ControlsLabel
@onready var game_over_panel: Panel = $GameOverPanel
@onready var game_over_label: Label = $GameOverPanel/VBoxContainer/GameOverLabel
@onready var restart_button: Button = $GameOverPanel/VBoxContainer/RestartButton

var player: Player

func _ready():
	add_to_group("game_ui")
	
	# Hide game over panel
	if game_over_panel:
		game_over_panel.hide()
	
	# Connect restart button
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	
	# Find player and connect signals
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		player.stress_changed.connect(_on_stress_changed)
		player.syringe_count_changed.connect(_on_syringe_count_changed)
		update_all_ui()

func _process(_delta):
	if player:
		# Update power XP continuously
		if power_xp_label:
			power_xp_label.text = "Power XP: %d" % player.power_xp

func update_all_ui():
	if not player:
		return
	
	_on_stress_changed(player.current_stress)
	_on_syringe_count_changed(player.syringe_count)
	
	if power_xp_label:
		power_xp_label.text = "Power XP: %d" % player.power_xp

func _on_stress_changed(new_stress: float):
	if stress_bar:
		stress_bar.value = new_stress
		
		# Change color based on stress level
		var stress_percent = new_stress / player.max_stress
		if stress_percent < 0.5:
			stress_bar.modulate = Color.GREEN
		elif stress_percent < 0.75:
			stress_bar.modulate = Color.YELLOW
		else:
			stress_bar.modulate = Color.RED
	
	if stress_label:
		stress_label.text = "Stress: %.0f/%.0f" % [new_stress, player.max_stress]

func _on_syringe_count_changed(count: int):
	if syringe_label:
		syringe_label.text = "Syringes: %d" % count

func show_game_over():
	if game_over_panel:
		game_over_panel.show()
		
		# Determine ending type
		var ending_message = ""
		if player and player.check_hallucination():
			ending_message = "CLINIC COLLAPSED\n\nYou used too many syringes...\nWas the gym even real?"
		else:
			ending_message = "CLINIC COLLAPSED\n\nThe stress was too much.\nNick has left the building."
		
		if game_over_label:
			game_over_label.text = ending_message

func _on_restart_pressed():
	get_tree().reload_current_scene()
