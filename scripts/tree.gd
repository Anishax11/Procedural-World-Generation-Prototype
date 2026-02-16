extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("tree" + str(randi_range(1,3)))


func _on_area_2d_body_entered(body: StaticBody2D) -> void:
	
	if body!=self:
		body.queue_free()
		print("Remove body from tree :",body.name)
