extends Area3D

@export var value = 25

signal picked_up


func _ready():
	body_entered.connect(_on_pickup)

func _on_pickup(body) -> void:
	if not body is CharacterBody3D:
		return
	else:
		body.rep += value
		picked_up.emit()
		queue_free()