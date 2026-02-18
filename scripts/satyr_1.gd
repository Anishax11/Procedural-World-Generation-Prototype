extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const POWER_UP = preload("uid://c3mcerku8g657")
const HEAL_POWER_UP = preload("uid://b42tu1ifegdgs")
const MEMORY_FRAGMENT = preload("uid://c3hyvh3gm8dmr")
var base_damage = 15
@onready var health_box_component: HealthBoxComponent = $HealthBoxComponent
var player
var speed = 35
var direction : Vector2 = Vector2(1,0)
var prev_state
var state_machine 
var wait_time = 3.0
var distance_to_player
var combat_manager
var player_hitbox
var attack_interval = 0.0
var max_attack_interval = 30
var max_stun_time = 20
var caster = false
const SATYR_SPELL = preload("uid://bd3t01afhjuf6")
var satyr_type = "white"


func _ready():
	var rand = randi_range(1,3)
	if rand == 1:
		satyr_type = "white"
	elif rand == 2:
		satyr_type = "purple"
	else:
		satyr_type = "red"
	player_hitbox = player.get_node("HitBoxComponent")
	state_machine = get_node("EnemyStateMachine")
	base_damage = base_damage*Global.level
	health_box_component.maxHealth = health_box_component.maxHealth*Global.level


func patrol():
	
	if animated_sprite_2d.animation!="walk" and animated_sprite_2d.animation!="die":
		animated_sprite_2d.play(satyr_type+"_walk")
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
	if caster:
		combat()
		return

	if animated_sprite_2d.animation!="walk" and animated_sprite_2d.animation!="die":
		animated_sprite_2d.play(satyr_type+"_walk")
	
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision.get_collider().name =="Player":
			combat()
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
	#print("CombatWD :",self.name)
	#update_animation()
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	attack()
	
func attack():
	#update_animation()
	if stunned:
		return

	if animated_sprite_2d.animation!="attack" and animated_sprite_2d.animation!="die":
		animated_sprite_2d.play(satyr_type+"_attack")
		
	if attack_interval <=0:
		if caster :
			var spell = SATYR_SPELL.instantiate()
			spell.type = satyr_type
			add_child(spell)	
			spell.animated_sprite_2d.flip_h  = animated_sprite_2d.flip_h 
			attack_interval = max_attack_interval
		else:
			player_hitbox.take_damage(base_damage)
			attack_interval = max_attack_interval
	else:
		attack_interval-=0.1
		
	
	
	
func die():

	update_animation()
	print("DIe")
	var power_up = HEAL_POWER_UP.instantiate()
	power_up.global_position = global_position
	get_parent().add_child(power_up)
	animated_sprite_2d.play(satyr_type+"_die")

	#if randi_range(1,Global.enemies_left) == 1:
		#var fragment = MEMORY_FRAGMENT.instantiate()
		#fragment.global_position = global_position
		#get_parent().add_child(fragment)
	#else:
		#if randi_range(1,5) == 3:
			#if randi_range(0,1) == 0:
				#var power_up = POWER_UP.instantiate()
				#power_up.global_position = global_position
				#get_parent().add_child(power_up)
			#else:
				#var power_up = HEAL_POWER_UP.instantiate()
				#power_up.global_position = global_position
				#get_parent().add_child(power_up)
		
	Global.enemies_left-=1		
	queue_free()

var stunned = false

func stun_effect():
	animated_sprite_2d.play(satyr_type+"_pushed")
	update_animation()
	var stun_time  = max_stun_time
	while(stun_time>=0):		
		stunned = true
		stun_time-=0.1
	stunned = false
	
func update_animation():
	if direction.x<0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
