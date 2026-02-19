extends Area2D

var heal_meter = 10
var message_box

func _ready() -> void:
	message_box = get_tree().current_scene.find_child("MessageBox")
	heal_meter = heal_meter*Global.level


func _on_body_entered(body: CharacterBody2D) -> void:
	if !visible:
		return
	body.get_node("HealthBoxComponent").heal(heal_meter)
	message_box.get_node("Message").text="Healed by "+str(heal_meter)
	visible = false
	await get_tree().create_timer(3).timeout
	if message_box.get_node("Message").text=="Healed by "+str(heal_meter): # remove after 3 secs if another message isnt being displayed
		message_box.get_node("Message").text=""
	queue_free()
	
