extends CharacterBody3D


@export var total_compensation = 300
@export var player_name = "Gary"


signal tc_changed(new_tc)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		total_compensation += 50
		tc_changed.emit(total_compensation)
	if Input.is_action_just_pressed("ui_down"):
		total_compensation -= 50
		tc_changed.emit(total_compensation)