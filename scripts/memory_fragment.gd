extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var memory_label
var message_label
var center_message_label 
var center_message_box

func _ready() -> void:
	var random = randi_range(0,2)
	if random == 1:
		animated_sprite_2d.play("light_green")
	elif random == 2:
		animated_sprite_2d.play("green")
	else:
		animated_sprite_2d.play("brown")
		
	memory_label = get_tree().current_scene.find_child("MemoryLabel")
	message_label = get_tree().current_scene.find_child("Message")
	center_message_label = get_tree().current_scene.find_child("CenterMessage")
	center_message_box =  get_tree().current_scene.find_child("CenterMessageBox")



func _on_body_entered(body) -> void:
	if body.name == "Player":
		audio_stream_player_2d.play()
		GlobalCanvasLayer.memory_fragments_acquired+=1
		memory_label.text = "Memory Fragments : " + str(GlobalCanvasLayer.memory_fragments_acquired) +"/" +str(GlobalCanvasLayer.total_memory_fragments)
		message_label.text="Memory Fragment acquired"
		visible = false
		if GlobalCanvasLayer.memory_fragments_acquired == GlobalCanvasLayer.total_memory_fragments:
			if GlobalCanvasLayer.worlds_left == 0:
				GlobalCanvasLayer.switching_worlds = true
				center_message_label.text="YOU WIN"
				center_message_label.visible_characters = 0
				center_message_box.visible = true
				center_message_box.get_node("PlayAgain").visible = true
				center_message_box.get_node("Quit").visible = true
				#GlobalCanvasLayer.switch_worlds()
				return
			center_message_label.text="All Memory Fragments acquired. You will be moved to another world"
			center_message_label.visible_characters = 0
			center_message_box.visible = true
			GlobalCanvasLayer.switch_worlds()
			
		await get_tree().create_timer(3).timeout
		call_deferred("queue_free")
