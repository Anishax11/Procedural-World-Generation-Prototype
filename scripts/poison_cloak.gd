extends Area2D

var parent
var damage = 25
var enemies_in_range : Array = []
var delay = 0
var type 
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var total_time = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
		
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1.0,1.0),2)
	parent  = get_parent()
	if type == "sound_wave":
		print("Soundwave")
		animated_sprite_2d.play("sound_wave")
		animated_sprite_2d.scale = Vector2(6,6)
	await get_tree().create_timer(total_time).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animated_sprite_2d.play("sound_wave")
	if delay<= 0:
		for e in enemies_in_range:
			e.take_damage(damage)
			delay = 1
	else:
		delay-=delta


func _on_area_entered(area: Area2D) -> void:
	if area is HitBoxComponent and area.get_parent()!=parent:
		enemies_in_range.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area is HitBoxComponent and area.get_parent()!=parent:
		enemies_in_range.erase(area)
