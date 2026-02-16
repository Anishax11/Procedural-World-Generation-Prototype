extends Area2D

var memory_label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2(randi_range(500,2250),randi_range(500,1500))
	GlobalCanvasLayer.memory_fragment_position = global_position
	memory_label = get_tree().current_scene.find_child("MemoryLabel")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Memory acquired")
		GlobalCanvasLayer.memory_fragments_acquired+=1
		memory_label.text = "Memory Fragments : " + str(GlobalCanvasLayer.memory_fragments_acquired) +"/" +str(GlobalCanvasLayer.total_memory_fragments)
		#GlobalCanvasLayer.update_memory_fragments()
		queue_free()
