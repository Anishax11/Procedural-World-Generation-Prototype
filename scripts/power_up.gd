extends Area2D

var damage_boost = 10
var message_box

func _ready() -> void:
	message_box = get_tree().current_scene.find_child("MessageBox")
	damage_boost = damage_boost*Global.level

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and visible:
		
		body.base_attack_damage+=damage_boost
		message_box.get_node("Message").text="Strength icremented by "+str(damage_boost)
		visible = false
		await get_tree().create_timer(3).timeout
		if message_box.get_node("Message").text=="Strength icremented by "+str(damage_boost): # remove after 3 secs if another message isnt being displayed
			message_box.get_node("Message").text=""
	
		queue_free()
