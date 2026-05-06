extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var total_compensation = 300
@export var player_name = "Gary"

signal tc_changed(_new_tc)

func _process(float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		total_compensation += 50
		emit_signal("tc_changed", total_compensation)
	if Input.is_action_just_pressed("ui_down"):
		total_compensation -= 50
		emit_signal("tc_changed", total_compensation)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()