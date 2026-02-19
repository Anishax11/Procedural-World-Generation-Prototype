extends CanvasLayer

var memory_fragments_acquired = 0
var total_memory_fragments = 5
var memory_fragment_position : Vector2
var distance_to_memory_fragment 
var player
var memory_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while(player == null):
		player = get_tree().current_scene.find_child("Player")
	while(memory_label == null):
		memory_label = get_tree().current_scene.find_child("MemoryLabel")

func switch_worlds():
	Global.dream = "forest"
	Global.level+=1.0
	get_tree().call_deferred("reload_current_scene")
