extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const POWER_UP = preload("uid://c3mcerku8g657")
const HEAL_POWER_UP = preload("uid://b42tu1ifegdgs")


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


func _ready():
	player_hitbox = player.get_node("HitBoxComponent")
	state_machine = get_node("EnemyStateMachine")

func patrol():
	#print("Patrol")
	if wait_time<=0:
		
		direction = Vector2(randi_range(-1,1),randi_range(-1,1))
		wait_time = 3.0
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		var normal = collision.get_normal()
		direction = direction.bounce(normal)
		
	direction = direction.normalized()	
	velocity = direction * speed
	
	


func chase():
	prev_state = state_machine.States.chase
	
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision.get_collider().name =="Player":
			attack()
		else:	
			#state_machine.state = state_machine.States.patrol 
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
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	attack()
	
func attack():
	animated_sprite_2d.play("attack")
	if attack_interval <=0:
		player_hitbox.take_damage(5)
		attack_interval = 5.0
	else:
		attack_interval-=0.1
	
	
func die():
	if randi_range(3,3) == 3:
		if randi_range(1,1) == 0:
			var power_up = POWER_UP.instantiate()
			power_up.global_position = global_position
			get_parent().add_child(power_up)
		else:
			var power_up = HEAL_POWER_UP.instantiate()
			power_up.global_position = global_position
			get_parent().add_child(power_up)
			
	queue_free()

var stunned = false

func stun_effect():
	var stun_time  = 30
	while(stun_time>=0):
		stunned = true
		stun_time-=0.1
	stunned = false
