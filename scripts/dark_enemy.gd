extends CharacterBody2D


@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const POWER_UP = preload("uid://c3mcerku8g657")
const HEAL_POWER_UP = preload("uid://b42tu1ifegdgs")
const MEMORY_FRAGMENT = preload("uid://c3hyvh3gm8dmr")
const ABILITY = preload("uid://bwuqg3lx5cbaf")

var base_damage = 15
@onready var health_box_component: HealthBoxComponent = $HealthBoxComponent
var player
var speed = 45
var direction : Vector2 = Vector2(1,0)
var prev_state
var state_machine 
var wait_time = 3.0
var distance_to_player
var combat_manager
var player_hitbox
var attack_interval = 0.0
var max_attack_interval = 1.0
var max_stun_time = 0.1
var dead = false
const SATYR_SPELL = preload("uid://bd3t01afhjuf6")
var stun_time = 0.0
var spell_damage = 30

func _ready():
	
	health_box_component.maxHealth = health_box_component.maxHealth*Global.level
	base_damage = base_damage*Global.level
	spell_damage = spell_damage*Global.level
	max_attack_interval = max_attack_interval/Global.level
	player_hitbox = player.get_node("HitBoxComponent")
	state_machine = get_node("EnemyStateMachine")
	

func patrol():
	
	if animated_sprite_2d.animation!="right" and animated_sprite_2d.animation!="die":
		animated_sprite_2d.play("right")
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
	#print("chase")
	if player.global_position.x<global_position.x:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	combat()
	direction = -player.direction
	return
	if animated_sprite_2d.animation!="right" and animated_sprite_2d.animation!="die":
		animated_sprite_2d.play("right")
	
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision.get_collider().name =="Player":
			direction = -collision.get_collider().direction
		else:	
			var normal = collision.get_normal()
			resolve_collision(normal)
	var next_pos  = navigation_agent_2d.get_next_path_position()
	direction  = (next_pos - global_position).normalized()
	move_and_slide()
	
	
func resolve_collision(normal):
	direction = direction.bounce(normal)
	state_machine.resolve_collision_time = 2.0
	
func combat():
	attack()
	
func attack():
	#update_animation()
	if animated_sprite_2d.animation!="attack" and animated_sprite_2d.animation!="die":
		animated_sprite_2d.play("_attack")
		
	if attack_interval <=0:
		
			var spell = SATYR_SPELL.instantiate()
			spell.type = "dark"
			spell.spell_damage = spell_damage
			add_child(spell)	
			spell.animated_sprite_2d.flip_h  = animated_sprite_2d.flip_h 
			attack_interval = max_attack_interval
			print("Print cast spell")

	
func die():
	if dead:
		return
	dead = true
	Global.dark_enemy_to_kill-=1
	update_animation()
	animated_sprite_2d.play("die")
	var fragment = MEMORY_FRAGMENT.instantiate()
	fragment.global_position = global_position
	get_parent().call_deferred("add_child", fragment)

	if Global.dark_enemy_to_kill == 0 :
		var ability = ABILITY.instantiate()
		ability.ability = "dark_spell"
		ability.global_position = global_position
		get_parent().add_child(ability)

	Global.enemies_left-=1		
	#queue_free()



func stun_effect():
	update_animation()
	stun_time  = max_stun_time

	
func update_animation():
	
	if direction.x<0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
