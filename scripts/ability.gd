extends Area2D

var ability


func _on_body_entered(body) -> void:
	if body.name == "Player":
		Global.add_ability(ability)
