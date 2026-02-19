extends CanvasLayer

var memory_fragments_acquired = 0
var total_memory_fragments = 5
var memory_fragment_position : Vector2
var distance_to_memory_fragment 
var player
var memory_label
var worlds_left# one world loaded by default throughh global script at start of game
var color_rect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while(player == null):
		player = get_tree().current_scene.find_child("Player")
	while(memory_label == null):
		memory_label = get_tree().current_scene.find_child("MemoryLabel")
	worlds_left = Global.dreams.size() - 1 
	
	 

func switch_worlds():
	
	color_rect = get_tree().current_scene.find_child("ColorRect")
	var mat = color_rect.material as ShaderMaterial
	var tween = create_tween()
	tween.tween_method(func(v): mat.set_shader_parameter("blur_amount", v), 0.0, 8.0, 5.5)
	await tween.finished
	if worlds_left == 0:
		print("You winn ")
		return
	Global.dream = Global.dreams[randi_range(0,worlds_left-1)]
	worlds_left-=1
	Global.dreams.erase(Global.dream)
	Global.level+=1.0
	get_tree().call_deferred("reload_current_scene")
	
		
	#var tween = create_tween()
	#tween.tween_property(color_rect, "color", Color(0.8, 0.6, 1.0, 1.0), 4.0) 
	#await tween.finished
	#print("Switch world called")
	#print("WOrlds left : ",worlds_left)
	#
	#Global.dream = Global.dreams[randi_range(0,worlds_left-1)]
	#worlds_left-=1
	#Global.dreams.erase(Global.dream)
	#Global.level+=1.0
	#get_tree().call_deferred("reload_current_scene")
	#tween.tween_callback(func():
		#
		#)
	
