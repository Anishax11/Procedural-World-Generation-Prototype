extends Area2D

class_name HitBoxComponent
@export var healthbox : Node2D
var player
var damage = 10 
var push_timer = 0.0
var push_velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().current_scene.find_child("Player")


func _process(delta: float) -> void:
	if push_timer > 0:
		push_timer -= delta
		get_parent().velocity = push_velocity
	else:
		push_timer = 0
		get_parent().velocity = Vector2.ZERO
		get_parent().animated_sprite_2d.play("default")
		
	get_parent().move_and_slide()

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
		
	push_effect(damage)
	get_parent().stun_effect()

func push_effect(damage):
	if get_parent() is StaticBody2D:
		return
	
	push_velocity = -get_parent().direction.normalized() * 200  # push strength
	push_timer = 0.2  # seconds
		
		
		
		
		

		
