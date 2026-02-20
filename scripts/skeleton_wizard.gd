extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const POWER_UP = preload("uid://c3mcerku8g657")
const HEAL_POWER_UP = preload("uid://b42tu1ifegdgs")
const MEMORY_FRAGMENT = preload("uid://c3hyvh3gm8dmr")
const SPELL = preload("uid://dwf1hndexyu7x")
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
var total_attack_interval = 30.0
var max_stun_time = 0.5
var stun_time = 0.0
var dead = false
const ABILITY = preload("uid://bwuqg3lx5cbaf")



func _ready():
	player_hitbox = player.get_node("HitBoxComponent")
	state_machine = get_node("EnemyStateMachine")
	total_attack_interval = total_attack_interval - total_attack_interval*0.1  # attacks get fasterr
	health_box_component.maxHealth = health_box_component.maxHealth*Global.level


func patrol():
	#print("Patorl")
	
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
	#print("chase")
	if player.global_position.x<global_position.x:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
		
	attack()
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision.get_collider().name =="Player":
			attack()
		else:	
			var normal = collision.get_normal()
			resolve_collision(normal)
			
	move_and_slide()
	
	
func resolve_collision(normal):
	direction = direction.bounce(normal)
	state_machine.resolve_collision_time = 2.0
	
	

func combat():
	#print("COmbat")
	direction = direction.bounce(direction)
	velocity = direction*speed
	move_and_slide()
	
func attack():
	if attack_interval <=0:
		var spell = SPELL.instantiate()
		spell.type = "ice"
		#update_animation()
		add_child(spell)	
		spell.animated_sprite_2d.flip_h  = animated_sprite_2d.flip_h 
		animated_sprite_2d.play("attack")
		
		attack_interval = total_attack_interval
	else:
		attack_interval-=0.1
	
	
func die():
	dead = true
	update_animation()
	animated_sprite_2d.play("die")
	Global.skeleton_wizards_to_kill-=1

	if randi_range(1,Global.enemies_left) == 1:
		var fragment = MEMORY_FRAGMENT.instantiate()
		fragment.global_position = global_position
		get_parent().add_child(fragment)
	else:
		if Global.skeleton_wizards_to_kill == 0 :
			var ability = ABILITY.instantiate()
			ability.ability = "ice_spell"
			ability.global_position = global_position
			get_parent().add_child(ability)
		else:
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
