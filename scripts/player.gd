extends CharacterBody2D

var dream = "forest"
enum States{combat,explore,move_to}
var state = States.explore
var enemies_in_range : Array = []
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
var base_attack_damage 
@onready var health_box_component: HealthBoxComponent = $HealthBoxComponent

@onready var time_scale_world: Node2D = $"../TimeScaleWorld"
var special_ability_cooldown = 0.0
var speed = 100
var direction : Vector2 = Vector2.ZERO
var last_dir = direction
var stunned = false

func _ready() -> void:
	base_attack_damage = Global.base_attack_damage*Global.level
	health_box_component.maxHealth = Global.maxHealth
	health_box_component.health = Global.maxHealth
	
func _physics_process(delta: float) -> void:
	
	
		delta = get_process_delta_time() / Engine.time_scale
		if special_ability_cooldown>0:
			special_ability_cooldown-=delta
	
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
			if direction.x==1:
				animated_sprite_2d.play("right")
				
		elif direction.y==-1:
			if direction.x==-1:
				animated_sprite_2d.play("left")
			if direction.x==1:
				animated_sprite_2d.play("right")

		position+=speed*direction*delta
		move_and_slide()
		
	
		
func _input(event: InputEvent) -> void:
		direction = Vector2.ZERO
		
		if Input.is_action_pressed("Shift"):
			speed=150
		else:
			speed=70	
		if Input.is_action_pressed("Up"):
			#direction.y = 0
			direction.y-=1
			last_dir = direction	
		if Input.is_action_pressed("Down"):
			#direction.y = 0
			direction.y+=1
			last_dir = direction	
		if Input.is_action_pressed("Right"):
			#direction.x = 0
			direction.x+=1
			last_dir = direction	
		if Input.is_action_pressed("Left"):
			#direction.x = 0
			direction.x-=1
			last_dir = direction	
		if Input.is_action_pressed("Base Attack"):
			
			#navigation_agent_2d.target_position = enemy_under_attack.get_parent().global_position
			#print("Target pos :",navigation_agent_2d.target_position)
			#print("Player pos :",global_position)
			base_attack()
		if Input.is_action_pressed("Special Ability"):
			if dream == "forest":
				slow_mo()
		
	
func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.play(animated_sprite_2d.animation+"_idle")


func base_attack():
	var anim = str(animated_sprite_2d.animation)
	if anim.contains("forward"):
		animated_sprite_2d.play("forward_base_attack")
	elif anim.contains("backward"):
		animated_sprite_2d.play("backward_base_attack")
	elif anim.contains("right"):
		animated_sprite_2d.play("right_base_attack")
	else:
		animated_sprite_2d.play("left_base_attack")
		
	for enemy in enemies_in_range:
		#print("Player dire : ",last_dir)
		#print("Enemy pos : ",enemy.global_position)
		if (last_dir.x >0 and enemy.global_position.x>=global_position.x) or (last_dir.x<0 and enemy.global_position.x<=global_position.x) or (last_dir.y<0 and enemy.global_position.y<=global_position.y) or (last_dir.y>0 and enemy.global_position.y>=global_position.y) :
			#print("enemy : ",enemy.name)
			enemy.take_damage(base_attack_damage)
			break
	
	
func combat():
	print("Player in combat mode")


func die():
	queue_free()
	get_tree().paused=true
	
func _on_range_area_entered(area: Area2D) -> void:
	
	if area is HitBoxComponent and area.get_parent()!=self  and !enemies_in_range.has(area):
		#print("Range enetered : ", area.get_parent().get_path())
		enemies_in_range.append(area)
	

func _on_range_area_exited(area: Area2D) -> void:
	if area is HitBoxComponent and !area.get_parent()==self:
		enemies_in_range.erase(area)

func slow_mo():
	if special_ability_cooldown>0:
		print("Time remianing : ",special_ability_cooldown)
		return
	special_ability_cooldown = 35.0
	var timer = Timer.new()
	Engine.time_scale   = 0.2
	speed = speed*100
	animated_sprite_2d.speed_scale = animated_sprite_2d.speed_scale*3
	await get_tree().create_timer(2).timeout
	Engine.time_scale   = 1
	speed = speed/100
	animated_sprite_2d.speed_scale = animated_sprite_2d.speed_scale/3
	
func stun_effect():
	pass
