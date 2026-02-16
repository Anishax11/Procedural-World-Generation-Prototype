extends Area2D

var heal_meter = 10


func _on_body_entered(body: CharacterBody2D) -> void:
	body.get_node("HealthBoxComponent").heal(heal_meter)
	queue_free()
