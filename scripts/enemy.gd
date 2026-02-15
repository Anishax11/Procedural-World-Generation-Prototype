extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var player
var speed = 50
var direction : Vector2 = Vector2.ZERO
enum States {patrol,chase,combat}
var state = States.patrol
var wait_time = 5.0
var distance_to_player



func patrol():
	print("Patrolling")
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
	print("Chasing")

	
	var next_pos  = navigation_agent_2d.get_next_path_position()
	direction  = (next_pos - global_position).normalized()
	if get_slide_collision_count() > 0:
		
		var collision = get_slide_collision(0)
		if collision.get_collider().name =="Player":
			print("Player caught, attack")
			combat()
			
		else:	
			var normal = collision.get_normal()
			state = States.patrol
		
	velocity = direction * speed
	move_and_slide()
	
	
	

func combat():
	print("Combat mode")
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	attack()
	#if distance_to_player>10 and distance_to_player<70:
		#print("Switch to chase")
		#state = States.chase
		



#func _on_range_body_entered(body: Node2D) -> void:
	#if body.name =="Player":
		#print("player in sight")
		#state = States.chase

func attack():
	animated_sprite_2d.play("attack")
	
