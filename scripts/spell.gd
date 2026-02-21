extends Area2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var spell_damage : int  = 20
@export var speed : int = 70


var direction : Vector2 = Vector2(0,1)
var type
var ice_rain = false
var player_cast_satyr_spell = false
var distance_travelled = 0
var total_time = 2
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const single_spell = preload("uid://dtaxxdfx777dk")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_2d.stream = single_spell
	audio_stream_player_2d.play()
	if ice_rain:
		type = "ice"
		animated_sprite_2d.play(type+"_attack")
		await get_tree().create_timer(total_time).timeout
		queue_free()
		#rotation_degrees = 90
		#global_position.y-=randi_range(10,100)
	elif player_cast_satyr_spell:
		
		animated_sprite_2d.play(type+"_attack")
		await get_tree().create_timer(total_time).timeout
		queue_free()
		
	elif type:
		animated_sprite_2d.play(type+"_attack")
		global_position = get_parent().global_position
		navigation_agent_2d.target_position = get_tree().current_scene.find_child("Player").global_position		
		
	
	#print("SPell ready at :",global_position)
	
func _process(delta: float) -> void:
	if !ice_rain and !player_cast_satyr_spell:
		var next_pos  = navigation_agent_2d.get_next_path_position()
		direction  = (next_pos - global_position).normalized()
		global_position+=direction*speed*delta
		if navigation_agent_2d.is_navigation_finished():
			call_deferred("queue_free")
			await get_tree().create_timer(0.1).timeout #wait to checkwdaw if area enetred is triggered
			print("nav finihsed Freed")
		
	else:
		global_position+=direction*speed*delta
		distance_travelled+=speed*delta
		if distance_travelled >= 150:
			print("150 dist travelled Freed")
			queue_free()
	

func _on_area_entered(area: Area2D) -> void:
	if area is HitBoxComponent and area.get_parent()!=get_parent():
		
		area.take_damage(spell_damage)
		animated_sprite_2d.play(type+"_shatter")
		


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	print("Freed")
