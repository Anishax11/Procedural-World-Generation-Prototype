extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.base_attack_damage+=10
		queue_free()
