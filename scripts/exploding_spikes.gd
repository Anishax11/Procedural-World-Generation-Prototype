extends Area2D

var speed = 0
var damage = 5
var direction
var parent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction :
		position+=direction*speed*delta


func _on_area_entered(area: Area2D) -> void:
	if area is HitBoxComponent and area.get_parent()!=parent:
		animated_sprite_2d.play("shatter")
		area.take_damage(damage)
		


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
