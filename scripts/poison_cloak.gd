extends Area2D

var parent
var damage = 25
var enemies_in_range : Array = []
var delay = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1.0,1.0),2)
	parent  = get_parent()
	await get_tree().create_timer(5).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
