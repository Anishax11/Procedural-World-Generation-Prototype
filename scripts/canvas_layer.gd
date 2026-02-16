extends CanvasLayer

var memory_fragments_acquired = 0
var total_memory_fragments = 5
var memory_fragment_position : Vector2
var distance_to_memory_fragment 
var player
@onready var memory_label: Label = $MemoryFragments/MemoryLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while(player == null):
		player = get_tree().current_scene.find_child("Player")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#distance_to_memory_fragment = player.global_position.distance_to(memory_fragment_position)
	#print("Dist to mem : ",distance_to_memory_fragment)
