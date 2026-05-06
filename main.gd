extends Node


@onready var player = $Player


func _ready() -> void:
	player.tc_changed.connect(_on_tc_changed)
	print(player.total_compensation)
	print(player.player_name)


func _on_tc_changed(new_tc):
	print("My name is %s and my total compensation is %s" % [player.player_name, new_tc])
	if new_tc <= 400:
		print("%s is a LOSER" % [player.player_name])
	else:
		print("%s works at FAANG" % [player.player_name])
