extends Node2D
@onready var bg: ColorRect = $CanvasLayer/BG
@onready var audio_ambient: AudioStreamPlayer2D = $CanvasLayer/AudioAmbient

const OPENING_SCENE = preload("uid://cftj62m0nk64r")
@onready var title_glow: PointLight2D = $CanvasLayer/Title/TitleGlow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(audio_ambient, "volume_db", 0.0, 3)

 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_button_down() -> void:
	var tween = create_tween()
	tween.tween_property(bg, "modulate:a", 0.0, 3)
	await tween.finished
	get_tree().change_scene_to_packed(OPENING_SCENE)


func _on_quit_button_down() -> void:
	get_tree().quit()
