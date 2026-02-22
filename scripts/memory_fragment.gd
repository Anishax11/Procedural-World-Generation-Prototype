extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var memory_label
var message_label
var center_message_label 
var center_message_box
var color_rect



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
	#center_message_label = get_tree().current_scene.find_child("CenterMessage")
	center_message_box =  get_tree().current_scene.find_child("CenterMessageBox")
	center_message_label = center_message_box.get_node("CenterMessage")
	color_rect = get_tree().current_scene.find_child("ColorRect")
	#



func _on_body_entered(body) -> void:
	if body.name == "Player":
		audio_stream_player_2d.play()
		GlobalCanvasLayer.memory_fragments_acquired+=1
		memory_label.text = "Memory Fragments : " + str(GlobalCanvasLayer.memory_fragments_acquired) +"/" +str(GlobalCanvasLayer.total_memory_fragments)
		message_label.text="Memory Fragment acquired"
		visible = false
		if GlobalCanvasLayer.memory_fragments_acquired == 1:#GlobalCanvasLayer.total_memory_fragments:
			if GlobalCanvasLayer.worlds_left == 0:
				GlobalCanvasLayer.switching_worlds = true
				GlobalCanvasLayer.switch_worlds()
				return
			if Global.dream == "forest":
				center_message_label.text="The innocence fades. The memories here are yours again. But the mind runs deeper..."
			elif Global.dream == "iceworld":
				center_message_label.text="The cold breaks. What was buried resurfaces. There is still more to reclaim..."
			else:
				center_message_label.text="The dead rest now. You have faced what was lost. The journey nears its end..."
				
			center_message_label.visible_characters = 0
			center_message_box.visible = true
			GlobalCanvasLayer.switch_worlds()
			
		await get_tree().create_timer(3).timeout
		call_deferred("queue_free")
