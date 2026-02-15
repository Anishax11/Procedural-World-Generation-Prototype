extends Area2D

class_name HitBoxComponent
@export var healthbox : Node2D
var player
var damage = 10 
#@export var attack_interval : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().current_scene.find_child("Player")




func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if player.state == player.States.combat and healthbox!=null:
			print("Enemy selected")
			player.enemy_under_attack = self
			
#func _on_body_entered(body: Node2D) -> void:
	#if healthbox!=null:
		#take_damage(damage)

func take_damage(damage):
	if healthbox!=null:
		healthbox.take_damage(damage)
		
