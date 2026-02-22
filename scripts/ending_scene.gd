extends Node2D
@onready var text: RichTextLabel = $CanvasLayer/Text
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var audio_ambient: AudioStreamPlayer2D = $CanvasLayer/AudioAmbient


var lines = [
	["The fragments are whole."],
	["The journey complete."],
	["You remember now."],
	["You remember everything."],
	["Memories collected : 15/15 "],
	["Worlds travelled : 3/3"],
	["Abilities remembered : "+str( Global.player_abilities.size() )+"/5"],
	[""],
	["WRAITHBORN"]
	
]
const MAIN_MENU = preload("uid://c7mjvsj61ohr0")
var delay = 2.0
var current_line = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(3).timeout
	play_next_line()



func play_next_line():
	if current_line >= lines.size():
		finish()
		return
	var entry = lines[current_line]
	var screen_text = entry[0]
	if screen_text == "":
		text.add_theme_font_size_override("normal_font_size", 180) 
	text.text = screen_text
	var tween = create_tween()
	tween.tween_property(text, "modulate:a", 1.0, 1.0)
	await tween.finished
	await get_tree().create_timer(delay).timeout
	tween = create_tween()
	tween.tween_property(text, "modulate:a", 0.0, 0.7)
	current_line+=1
	play_next_line()
	
func finish():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(canvas_layer, "modulate:a", 0.0, 3)
	tween.tween_property(audio_ambient, "volume_db",-20, 3)
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_packed(MAIN_MENU)
