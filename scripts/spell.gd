extends Area2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 250
var direction
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation_agent_2d.target_position = get_tree().current_scene.find_child("Player").global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var next_pos  = navigation_agent_2d.get_next_path_position()
	direction  = (next_pos - global_position).normalized()
	global_position+=direction*speed*delta
	if navigation_agent_2d.is_navigation_finished():
		queue_free()
	

func _on_area_entered(area: Area2D) -> void:
	if area is HitBoxComponent and area.get_parent()!=get_parent():
		area.take_damage(20)
		queue_free()
