extends Area3D

@export var damage = 10
@export var knockback_str = 20

func _ready():
	body_entered.connect(_on_pickup)

func _on_pickup(body) -> void:
	if not body is CharacterBody3D:
		return
	elif body is CharacterBody3D and (body.invuln_timer <= 0):
		body.health -= damage
		print(body.health)
		body.invuln_timer = 1.0
		var knockback_direction = (body.global_position - global_position).normalized()
		body.velocity = knockback_direction * knockback_str
		body.move_and_slide()