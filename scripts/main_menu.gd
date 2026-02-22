extends Node2D
@onready var bg: ColorRect = $CanvasLayer/BG
@onready var audio_ambient: AudioStreamPlayer2D = $CanvasLayer/AudioAmbient
@onready var player: AnimatedSprite2D = $CanvasLayer/Player
@onready var satyr_spell: AnimatedSprite2D = $CanvasLayer/SatyrSpell
@onready var ghost: AnimatedSprite2D = $CanvasLayer/Ghost
@onready var satyrs: AnimatedSprite2D = $CanvasLayer/Satyrs
@onready var skeleton_wizard: AnimatedSprite2D = $CanvasLayer/SkeletonWizard
const OPENING_SCENE = preload("uid://cftj62m0nk64r")
@onready var title_glow: PointLight2D = $CanvasLayer/Title/TitleGlow
@onready var title: RichTextLabel = $CanvasLayer/Title

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(audio_ambient, "volume_db", 0.0, 3)
	

 

func _process(delta: float) -> void:
	skeleton_wizard.global_position.x-=50*delta
	satyr_spell.global_position.x+=50*delta
	if player.global_position.x >= 800:
		player.play("idle")
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(player,"self_modulate:a",0,2)
		tween.tween_property(ghost,"self_modulate:a",0,2)
		await tween.finished
		return
	player.position.x+=50*delta


func _on_start_game_button_down() -> void:
	var tween = create_tween()
	tween.tween_property(bg, "modulate:a", 0.0, 3)
	await tween.finished
	get_tree().change_scene_to_packed(OPENING_SCENE)


func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_satyrs_animation_finished() -> void:
	var tween = create_tween()
	tween.tween_property(satyrs, "modulate:a", 0.0, 2.0)
