extends Node2D

@onready var silhouette: Sprite2D = $CanvasLayer/Silhouette
@onready var text: RichTextLabel = $CanvasLayer/Text
@onready var world_overlay: ColorRect = $CanvasLayer/WorldOverlay
@onready var audio_ambient = $CanvasLayer/AudioAmbient
@onready var audio_sfx = $CanvasLayer/AudioSFX
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var lines = [
	["Where does a journey begin…", 1, 2.5, ""],
	["When you step forward…", 0, 2.5, ""],
	["Or when you remember why you started?", 2, 3.0, "memory_snap"],
	["", 0, 1.2, ""],
	["You don't remember how you got here.", 0, 2.8, "heartbeat"],
	["Only that something is missing.", 0, 2.5, ""],
	["", 0, 0.5, "show_silhouette"],
	["Your memories are scattered.", 1, 2.2, ""],
	["Each world you enter… is a piece of you.", 0, 2.8, ""],
	["Each enemy… a part of yourself you tried to forget.", 2, 3.0, ""],
	["", 0, 0.3, "show_worlds"],
	["Memory is not linear.", 1, 2.2, ""],
	["Your mind will surface what it must.", 0, 2.5, ""],
	["", 0, 0.8, ""],
	["Collect what remains.", 0, 1.8, ""],
	["Rebuild yourself.", 0, 1.8, ""],
	["And finish the journey.", 0, 3.0, ""],
]

var positions = {
	0: Vector2(0.5, 0.5),
	1: Vector2(0.2, 0.25),
	2: Vector2(0.75, 0.72),
}

var current_line = 0
var viewport_size


func _ready() -> void:
	viewport_size = get_viewport().get_visible_rect().size
	text.modulate.a = 0
	world_overlay.modulate.a = 0
	silhouette.modulate.a = 0
	#audio_ambient.play()
	play_next_line()
	
	
func play_next_line():
	print("PLay line called")
	if current_line >= lines.size():
		finish()
		return
	var entry = lines[current_line]
	var screen_text = entry[0]
	var pos_preset = entry[1]
	var delay = entry[2]
	var sfx = entry[3]
	print(screen_text)
	if screen_text == "":
		handle_sfx(sfx)
		current_line+=1
		await get_tree().create_timer(delay).timeout
		play_next_line()
		return
		
	text.text = screen_text
	handle_sfx(sfx)
	
	var tween = create_tween()
	tween.tween_property(text, "modulate:a", 1.0, 1.0)
	await tween.finished
	await get_tree().create_timer(delay).timeout
	
	tween = create_tween()
	tween.tween_property(text, "modulate:a", 0.0, 0.7)
	await tween.finished
	current_line += 1
	play_next_line()

   
func show_silhouette():
	var tween = create_tween()
	tween.tween_property(silhouette, "modulate:a", 0.85, 2.0)
	await get_tree().create_timer(3.0).timeout
	tween = create_tween()
	tween.tween_property(silhouette, "modulate:a", 0.0, 1.5) 
	
func finish():
	pass	
	
func handle_sfx(sfx):
	pass	
