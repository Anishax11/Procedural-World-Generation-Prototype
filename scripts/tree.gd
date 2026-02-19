extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	if Global.dream == "forest":
		animated_sprite_2d.play("tree" + str(randi_range(1,3)))
	else:
		animated_sprite_2d.play("tree" + str(randi_range(4,6)))


func _on_area_2d_body_entered(body) -> void:
	if body!=self and body is StaticBody2D:
		body.queue_free()
