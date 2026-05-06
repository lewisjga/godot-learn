extends CharacterBody3D

@onready var _camera := $CameraPivot/SpringArm3D/PlayerCam as Camera3D
@onready var _camera_pivot := $CameraPivot as Node3D

@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)
@export var speed = 5.0
@export var acceleration = 4.0
@export var jump_speed = 8.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta
	get_move_input(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_camera_pivot.rotation.x -= event.screen_relative.y * mouse_sensitivity
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.screen_relative.x * mouse_sensitivity


func get_move_input(delta: float):
	var vy = velocity.y
	velocity.y = 0

	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, _camera_pivot.rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		vy = jump_speed
	velocity.y = vy