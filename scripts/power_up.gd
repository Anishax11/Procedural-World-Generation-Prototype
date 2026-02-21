extends Area2D

var damage_boost = 10
var message_box
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	message_box = get_tree().current_scene.find_child("MessageBox")
	damage_boost = damage_boost*Global.level

func _on_body_entered(body) -> void:
	if body.name == "Player" and visible:
		audio_stream_player_2d.play()
		body.base_attack_damage+=damage_boost
		message_box.get_node("Message").text="Strength icremented by "+str(damage_boost)
		visible = false
		await get_tree().create_timer(3).timeout
		if message_box.get_node("Message").text=="Strength icremented by "+str(damage_boost): # remove after 3 secs if another message isnt being displayed
			message_box.get_node("Message").text=""
		queue_free()
