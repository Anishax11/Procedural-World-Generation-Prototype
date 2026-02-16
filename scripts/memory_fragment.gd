extends Area2D

var memory_label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	memory_label = get_tree().current_scene.find_child("MemoryLabel")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		print("Memory acquired")
		GlobalCanvasLayer.memory_fragments_acquired+=1
		memory_label.text = "Memory Fragments : " + str(GlobalCanvasLayer.memory_fragments_acquired) +"/" +str(GlobalCanvasLayer.total_memory_fragments)
		Global.base_attack_damage+=20
		Global.maxHealth+=30
		queue_free()
