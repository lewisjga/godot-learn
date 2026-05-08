extends Node

const RECORD_SCENE = preload("res://record.tscn")
const HAZARD_SCENE = preload("res://hazard.tscn")

func _spawn_records(coords: Vector3):
	var record = RECORD_SCENE.instantiate()
	record.position = coords
	add_child(record)

func _ready() -> void:
	_spawn_records(Vector3(15, 0, 20))
	_spawn_records(Vector3(1, 5, 12))
