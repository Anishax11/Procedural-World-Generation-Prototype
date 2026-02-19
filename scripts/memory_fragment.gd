extends Area2D

var memory_label
var message_label
var center_message_label 
var center_message_box
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	memory_label = get_tree().current_scene.find_child("MemoryLabel")
	message_label = get_tree().current_scene.find_child("Message")
	center_message_label = get_tree().current_scene.find_child("CenterMessage")
	center_message_box =  get_tree().current_scene.find_child("CenterMessageBox")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_body_entered(body) -> void:
	if body.name == "Player":
		print("Memory acquired")
		GlobalCanvasLayer.memory_fragments_acquired+=1
		memory_label.text = "Memory Fragments : " + str(GlobalCanvasLayer.memory_fragments_acquired) +"/" +str(GlobalCanvasLayer.total_memory_fragments)
		message_label.text="Memory Fragment acquired"
		visible = false
		if GlobalCanvasLayer.memory_fragments_acquired == 1:
			if GlobalCanvasLayer.worlds_left == 0:
				center_message_label.text="YOU WIN"
				center_message_box.visible = true
				center_message_box.get_node("PlayAgain").visible = true
				center_message_box.get_node("Quit").visible = true
				GlobalCanvasLayer.switch_worlds()
				return
			center_message_label.text="All Memory Fragments acquired. You will be moved to another world"
			center_message_box.visible = true
			GlobalCanvasLayer.switch_worlds()
		await get_tree().create_timer(3).timeout
		call_deferred("queue_free")
