extends CanvasLayer

var memory_fragments_acquired = 0
var total_memory_fragments = 5
var memory_fragment_position : Vector2
var distance_to_memory_fragment 
var switching_worlds = false
var worlds_left# one world loaded by default throughh global script at start of game
var color_rect
const ENDING_SCENE = preload("uid://0t6axhpt64ou")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	worlds_left = Global.dreams.size() - 1 

func switch_worlds():
	switching_worlds = true
	color_rect = get_tree().current_scene.find_child("ColorRect")
	var mat = color_rect.material as ShaderMaterial
	var tween = create_tween()
	tween.tween_method(func(v): mat.set_shader_parameter("blur_amount", v), 0.0, 8.0, 7)
	await tween.finished
	if worlds_left == 0:
				var t = create_tween()
				t.tween_property(color_rect,"color",Color(0,0,0,1),2.0)
				await t.finished
				get_tree().change_scene_to_packed(ENDING_SCENE)
				return
	Global.dream = Global.dreams[randi_range(0,worlds_left-1)]
	worlds_left-=1
	Global.dreams.erase(Global.dream)
	Global.level+=1.0
	switching_worlds = false
	get_tree().call_deferred("reload_current_scene")
	
	
func _on_play_again_button_down() -> void:
	Global.player_abilities = []
	Global.dreams = ["forest","iceworld","graveyard"]
	Global.level = 1
	worlds_left = Global.dreams.size() - 1
	memory_fragments_acquired = 0
	Global.start_game() #randomly selects a dream
	#print("Start game called")
	get_tree().reload_current_scene()

func _on_quit_button_down() -> void:
	
	get_tree().quit()
