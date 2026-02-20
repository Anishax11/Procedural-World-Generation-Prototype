extends Area2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var spell_damage : int  = 20
@export var speed : int = 70
var direction
var type
var ice_rain = false
var distance_travelled = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if type:
		animated_sprite_2d.play(type+"_attack")
		global_position = get_parent().global_position
		navigation_agent_2d.target_position = get_tree().current_scene.find_child("Player").global_position
	if ice_rain:
		type = "ice"
		await get_tree().create_timer(2).timeout
		queue_free()
		#rotation_degrees = 90
		#global_position.y-=randi_range(10,100)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !ice_rain:
		var next_pos  = navigation_agent_2d.get_next_path_position()
		direction  = (next_pos - global_position).normalized()
		global_position+=direction*speed*delta
		if navigation_agent_2d.is_navigation_finished():
			call_deferred("queue_free")
	else:
		global_position+=direction*speed*delta
		distance_travelled+=speed*delta
		if speed*delta >= 150:
			queue_free()
	

func _on_area_entered(area: Area2D) -> void:
	if area is HitBoxComponent and area.get_parent()!=get_parent():
		area.take_damage(spell_damage)
		animated_sprite_2d.play(type+"_shatter")
		


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
