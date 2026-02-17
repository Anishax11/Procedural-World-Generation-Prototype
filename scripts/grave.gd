extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("grave"+str(randi_range(1,4)))
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body!=self and body is StaticBody2D:
		body.queue_free()
