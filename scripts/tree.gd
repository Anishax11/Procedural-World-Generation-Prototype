extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("tree" + str(randi_range(1,3)))
