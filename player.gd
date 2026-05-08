extends CharacterBody3D

@onready var _camera := $CameraPivot/SpringArm3D/PlayerCam as Camera3D
@onready var _camera_pivot := $CameraPivot as Node3D

@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)
@export var health = 100
@export var speed = 5.0
@export var acceleration = 4.0
@export var jump_speed = 8.0
@export var coyote_time = 0.2
@export var jump_buffer_time = 0.4
@export var jump_cut_factor = 0.8
@export var invuln_timer = 0.0
@export var rep = 0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var coyote_timer = 0.0
var jump_buffer_timer = 0.0


func _physics_process(delta: float):
	coyote_timer -= delta
	jump_buffer_timer -= delta
	invuln_timer -= delta

	if is_on_floor():
		coyote_timer = coyote_time
    
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	if not is_on_floor() and coyote_timer <= 0:
		velocity.y -= gravity * delta

	get_move_input(delta)
	move_and_slide()

	if not Input.is_action_pressed("jump") and velocity.y > 0:
		velocity.y *= jump_cut_factor

	var can_jump = is_on_floor() or coyote_timer > 0
	if jump_buffer_timer > 0 and can_jump:
		velocity.y = jump_speed
		coyote_timer = 0.0
		jump_buffer_timer = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_camera_pivot.rotation.x -= event.screen_relative.y * mouse_sensitivity
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.screen_relative.x * mouse_sensitivity


func get_move_input(delta: float):
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, _camera_pivot.rotation.y)
	var friction = acceleration if dir.length() > 0.1 else 10.0
	velocity = lerp(velocity, dir * speed, friction * delta)