extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

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
var resolve_collision_time = 50.0

func _ready():
	player_hitbox = player.get_node("HitBoxComponent")
	state_machine = get_node("EnemyStateMachine")

func patrol():
	#print("Patrol")
	if wait_time<=0:
		
		direction = Vector2(randi_range(-1,1),randi_range(-1,1))
		if prev_state == state_machine.States.chase:
			state_machine.state = state_machine.States.chase
		wait_time = 1.0
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		var normal = collision.get_normal()
		direction = direction.bounce(normal)
		
	direction = direction.normalized()	
	velocity = direction * speed
	
	


func chase():
	#print("Chase")
	prev_state = state_machine.States.chase
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision.get_collider().name =="Player":
			attack()
		else:	
			state_machine.state = state_machine.States.patrol 
			#var normal = collision.get_normal()
			#resolve_collision(normal)

	var next_pos  = navigation_agent_2d.get_next_path_position()
	direction  = (next_pos - global_position).normalized()
	
		
	velocity = direction * speed
	move_and_slide()
	
	
func resolve_collision(normal):
	direction = direction.bounce(normal)
	while(resolve_collision_time>0):
		velocity = direction * speed
		move_and_slide()
		resolve_collision_time-=1
	resolve_collision_time = 25
	

func combat():
	print("CombatWD")
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	attack()
	
func attack():
	animated_sprite_2d.play("attack")
	if player_hitbox==null:
		print("Player hibox null")
	#else:
		#print("Player caught, attack")
	if attack_interval <=0:
		player_hitbox.take_damage(5)
		attack_interval = 5.0
	else:
		attack_interval-=0.1
	
	
func die():
	queue_free()

var stunned = false

func stun_effect():
	var stun_time  = 30
	while(stun_time>=0):
		stunned = true
		stun_time-=0.1
	stunned = false
