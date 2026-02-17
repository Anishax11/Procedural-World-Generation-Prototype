extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi_range(1,2)==1:
		animated_sprite_2d.play("statue"+str(randi_range(1,2)))
	else:
		animated_sprite_2d.play("tree"+str(randi_range(1,3)))
