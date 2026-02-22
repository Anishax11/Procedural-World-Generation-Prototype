extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const POWER_UP = preload("uid://c3mcerku8g657")
const HEAL_POWER_UP = preload("uid://b42tu1ifegdgs")
const MEMORY_FRAGMENT = preload("uid://c3hyvh3gm8dmr")
var base_damage = 5
@onready var health_box_component: HealthBoxComponent = $HealthBoxComponent
var player
var speed = 35
var direction : Vector2 = Vector2.ZERO
var prev_state
var state_machine 
var wait_time = 5.0
var distance_to_player
var combat_manager
var player_hitbox
var attack_interval = 0.0
var max_stun_time = 0.5 #secs
var stun_time = 0.0
var dead = false
var start_moving = false

func _ready():
	await get_tree().create_timer(5).timeout
	start_moving = true
	player_hitbox = player.get_node("HitBoxComponent")
	state_machine = get_node("EnemyStateMachine")
	base_damage = base_damage*Global.level
	health_box_component.maxHealth = health_box_component.maxHealth*Global.level


func patrol():
	if !start_moving:
		return
	animated_sprite_2d.play("walk")
	if wait_time<=0:
		
		direction = Vector2(randi_range(-1,1),randi_range(-1,1))
		wait_time = 3.0
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		var normal = collision.get_normal()
		direction = direction.bounce(normal)
	update_animation()
	direction = direction.normalized()	
	velocity = direction * speed
	
	


func chase():
	if !start_moving:
		return

	if animated_sprite_2d.animation!="walk" and animated_sprite_2d.animation!="die":
		animated_sprite_2d.play("walk")
	
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision.get_collider().name =="Player":
			attack()
		else:	
			var normal = collision.get_normal()
			resolve_collision(normal)
	update_animation()
	var next_pos  = navigation_agent_2d.get_next_path_position()
	direction  = (next_pos - global_position).normalized()
	
	move_and_slide()
	
	
func resolve_collision(normal):
	direction = direction.bounce(normal)
	state_machine.resolve_collision_time = 2.0
	
	

func combat():
	if !start_moving:
		return
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	attack()
	
func attack():
	if direction.x<0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	if animated_sprite_2d.animation!="attack" and animated_sprite_2d.animation!="die":
		animated_sprite_2d.play("attack")
		
	if attack_interval <=0:
		player_hitbox.take_damage(base_damage)
		attack_interval = 5.0
	else:
		attack_interval-=0.1
	
	
func die():
	dead = true
	update_animation()
	animated_sprite_2d.play("die")
	if randi_range(1,5) == 3:
			if randi_range(0,1) == 0:
				var power_up = POWER_UP.instantiate()
				power_up.global_position = global_position
				get_parent().add_child(power_up)
			else:
				var power_up = HEAL_POWER_UP.instantiate()
				power_up.global_position = global_position
				get_parent().add_child(power_up)
		
	Global.enemies_left-=1		
	queue_free()


func stun_effect():
	stun_time  = max_stun_time

	
func update_animation():
	if direction.x<0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
