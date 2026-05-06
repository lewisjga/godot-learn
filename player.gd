extends CharacterBody3D

@onready var _camera := $CameraPivot/SpringArm3D/PlayerCam as Camera3D
@onready var _camera_pivot := $CameraPivot as Node3D

@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)
@export var total_compensation = 300
@export var player_name = "Gary"
@export var speed = 5.0
@export var acceleration = 4.0
@export var jump_speed = 8.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumping = false


signal tc_changed(new_tc)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		total_compensation += 50
		tc_changed.emit(total_compensation)
	if Input.is_action_just_pressed("ui_down"):
		total_compensation -= 50
		tc_changed.emit(total_compensation)


func _physics_process(delta):
	velocity.y += -gravity * delta
	get_move_input(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	# Mouselook implemented using `screen_relative` for resolution-independent sensitivity.
	if event is InputEventMouseMotion:
		_camera_pivot.rotation.x -= event.screen_relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.screen_relative.x * mouse_sensitivity


func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0

	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, _camera_pivot.rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)

	if Input.is_action_just_pressed("ui_accept"):
		vy = jump_speed
		jumping = true
	velocity.y = vy
