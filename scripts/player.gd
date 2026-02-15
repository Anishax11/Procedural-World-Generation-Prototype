extends CharacterBody2D

var turn = true
var dream = "forest"
enum States{combat,explore,move_to}
var state = States.explore
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

var worldshade = {
	"forest" ={"color" :"3e23663d",
					"opacity" : 0.2
					 } 
}

var speed = 100
var direction : Vector2
var enemy_under_attack # pick an enemy(hitbox) to attack during combat
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var selected_attack
var combat_manager
func _ready():
	color_rect.color = worldshade[dream]["color"]
	color_rect.color.a = worldshade[dream]["opacity"]
	combat_manager = get_tree().current_scene.find_child("CombatManager")
	
func _physics_process(delta: float) -> void:
	if state == States.combat:
		return
	elif state == States.move_to:
		print("State is move to enemy")
		move_to_enemy()
		
	elif state == States.explore:
		
		if direction==Vector2(0,1):
			animated_sprite_2d.play("forward")
		if direction==Vector2(0,-1):
			animated_sprite_2d.play("backward")
		if direction==Vector2(-1,0):
			animated_sprite_2d.play("left")
		if direction==Vector2(1,0):
			animated_sprite_2d.stop
			animated_sprite_2d.play("right")	
			
		if direction.y==1:
			
			if direction.x==-1:
				animated_sprite_2d.play("left")
				#print("MOving down left")
			if direction.x==1:
				
				animated_sprite_2d.play("right")
				#print("MOving down right")
				

		elif direction.y==-1:
			
			if direction.x==-1:
				animated_sprite_2d.play("left")
				#print("MOving up left")
			if direction.x==1:
				animated_sprite_2d.play("right")
				#print("MOving up right")

			
		position+=speed*direction*delta
		move_and_slide()
		
	
		
func _input(event: InputEvent) -> void:

		if Input.is_action_pressed("Base Attack") and turn:
			#navigation_agent_2d.target_position = enemy_under_attack.get_parent().global_position
			#print("Target pos :",navigation_agent_2d.target_position)
			#print("Player pos :",global_position)
			print("Base attack selected")
			base_attack()

	
		direction=Vector2.ZERO
		if Input.is_action_pressed("Shift"):
			speed=150
		else:
			speed=70	
		if Input.is_action_pressed("Up"):
			direction.y-=1
		if Input.is_action_pressed("Down"):
			direction.y+=1
		if Input.is_action_pressed("Right"):
			direction.x+=1
		if Input.is_action_pressed("Left"):
			direction.x-=1
			
	
	
	


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.play(animated_sprite_2d.animation+"_idle")


func base_attack():
	
	animated_sprite_2d.play("base_attack")
	enemy_under_attack.take_damage(40)
	combat_manager.turn_queueu.append(enemy_under_attack.get_parent())
	
func move_to_enemy():
	print("Player moving")
	var next_pos = navigation_agent_2d.get_next_path_position()
	direction = (next_pos-global_position).normalized()
	#if get_slide_collision_count() > 0:
		#print("Player collsion")
		#var collision = get_slide_collision(0)
		#if collision.get_collider()!=null:
			#print("Collision body :",collision.get_collider().name)
			#collision.get_collider().queue_free()
	if navigation_agent_2d.is_navigation_finished():
		print("Target reached")
		base_attack()
		turn = false
		state = States.combat

	velocity = direction*speed	
	move_and_slide()


func combat():
	print("Player in combat mode")
	if turn:
		print("select an attack")

func die():
	queue_free()
	get_tree().paused=true
	
