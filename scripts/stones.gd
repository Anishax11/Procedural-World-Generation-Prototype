extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	var random = randi_range(1,2)
	if random<2:
		animated_sprite_2d.play("flower"+ str(randi_range(1,3)))
	else:
		animated_sprite_2d.play("stone" + str(randi_range(1,4)))
