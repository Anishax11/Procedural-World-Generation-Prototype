extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	var random = randi_range(1,5)
	if Global.dream == "forest":
		if random<2:
			animated_sprite_2d.play("fire")
		else:
			animated_sprite_2d.play("stump")
	elif Global.dream == "graveyard":
		if random==1:
			animated_sprite_2d.play("candle")
		elif random==2:
			animated_sprite_2d.play("skeleton_hand")
		else:
			animated_sprite_2d.play("lantern")
			
	elif Global.dream == "iceworld":
		if random==1:
			animated_sprite_2d.play("ice_cone")
		elif random ==2:
			animated_sprite_2d.play("ice_figure")
		else:
			animated_sprite_2d.play("ice_cave")
		

func _on_area_2d_body_entered(body: StaticBody2D) -> void:
	if body!=self:
		body.queue_free()
