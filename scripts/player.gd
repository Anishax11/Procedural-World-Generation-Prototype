extends CharacterBody2D

var dream = "forest"
enum States{combat,explore,move_to}
var state = States.explore
var enemies_in_range : Array = []
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
var base_attack_damage 
@onready var health_box_component: HealthBoxComponent = $HealthBoxComponent
var special_ability_cooldown = 0.0
var speed = 100
var direction : Vector2 = Vector2.RIGHT
var last_dir = direction
var stunned = false
var center_message_box
var center_message_label
const SPELL = preload("uid://dwf1hndexyu7x")
const SHOCK_WAVE = preload("uid://q8yib80wufjq")
const SATYR_SPELL = preload("uid://bd3t01afhjuf6")




func _ready() -> void:
	center_message_box =  get_tree().current_scene.find_child("CenterMessageBox")
	center_message_label =  get_tree().current_scene.find_child("CenterMessage")
	GlobalCanvasLayer.memory_fragments_acquired = 0 #set to zero at the beginning of every world
	base_attack_damage = Global.base_attack_damage*Global.level
	health_box_component.maxHealth = Global.maxHealth
	health_box_component.health = Global.maxHealth
	
func _physics_process(delta: float) -> void:
		#print(direction)
		velocity = Vector2.ZERO
		direction.y = 0
		#direction = Vector2.ZERO
		
		if Input.is_action_pressed("Up"):
			direction.y = 0
			direction.y-=1
			last_dir = direction	
			animated_sprite_2d.play("walk")
			velocity = direction*speed
			
		if Input.is_action_pressed("Down"):
			direction.y = 0
			direction.y+=1
			last_dir = direction	
			animated_sprite_2d.play("walk")
			velocity = direction*speed
			
		if Input.is_action_pressed("Right"):
			direction.x = 0
			direction.x+=1
			last_dir = direction
			animated_sprite_2d.play("walk")	
			velocity = direction*speed
			
		if Input.is_action_pressed("Left"):
			direction.x = 0
			direction.x-=1
			last_dir = direction	
			animated_sprite_2d.play("walk")
			velocity = direction*speed
	
		delta = get_process_delta_time() / Engine.time_scale
		if special_ability_cooldown>0:
			special_ability_cooldown-=delta
			
		if direction ==Vector2(0,0):
			direction = Vector2(1,0)
		update_animation()
		move_and_slide()
		
		
func _input(event: InputEvent) -> void:
		update_animation()
		if Input.is_action_pressed("Shift"):
			speed=100
		else:
			speed=70	
		
		#last_dir = direction	
		if Input.is_action_pressed("Base Attack"):
			base_attack()
			
		if Input.is_action_pressed("Special Ability"):
			satyr_spell()
			#shock_wave()
			#ice_rain() #if Global.player_abilities.has[ice_spell] 
			#if dream == "forest":
				#slow_mo()
				
func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.play("idle")
	update_animation()


func base_attack():
	animated_sprite_2d.play("base_attack")
	update_animation()
	for enemy in enemies_in_range:
		
		if (last_dir.x >0 and enemy.global_position.x>=global_position.x) or (last_dir.x<0 and enemy.global_position.x<=global_position.x) or (last_dir.y<0 and enemy.global_position.y<=global_position.y) or (last_dir.y>0 and enemy.global_position.y>=global_position.y) :
			#print("enemy : ",enemy.name)
			enemy.take_damage(base_attack_damage)
			break
	
	
func combat():
	print("Player in combat mode")


func die():
	if GlobalCanvasLayer.memory_fragments_acquired == GlobalCanvasLayer.total_memory_fragments:
		return
	
	center_message_label.text="GAME OVER"
	center_message_label.visible_characters = 0
	center_message_box.visible = true
	center_message_box.get_node("PlayAgain").visible = true
	center_message_box.get_node("Quit").visible = true
	GlobalCanvasLayer.worlds_left = 0
	GlobalCanvasLayer.switch_worlds()
	#queue_free()
	#get_tree().paused=true
	
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
	Engine.time_scale   = 0.2
	speed = speed*100
	animated_sprite_2d.speed_scale = animated_sprite_2d.speed_scale*3
	await get_tree().create_timer(2).timeout
	Engine.time_scale   = 1
	speed = speed/100
	animated_sprite_2d.speed_scale = animated_sprite_2d.speed_scale/3

func ice_rain():
	#print("ICe rain called")
	var starting_pos = global_position.x-30
	for i in range(5):
		var ice	= SPELL.instantiate()
		ice.ice_rain = true
		ice.direction = Vector2(last_dir.x,0)
		ice.global_position = global_position
		ice.scale = Vector2(0.8,0.8)
		ice.top_level = true
		add_child(ice)
		ice.get_node("AnimatedSprite2D").flip_h = animated_sprite_2d.flip_h
		ice.global_position.x = starting_pos
		starting_pos+=10
		#print("Ice spike added")
	
func shock_wave():
	var shockwave = SHOCK_WAVE.instantiate()
	add_child(shockwave)
	
func satyr_spell():
	var starting_pos = global_position.y-30
	for i in range(5):
		var satyr_spell	= SATYR_SPELL.instantiate()
		satyr_spell.player_cast_satyr_spell = true
		satyr_spell.type = "red"
		satyr_spell.direction = Vector2(last_dir.x,0)
		#satyr_spell.global_position = Vector2(global_position.x,starting_pos)
		satyr_spell.global_position = global_position
		satyr_spell.scale = Vector2(0.6,0.6)
		add_child(satyr_spell)
		satyr_spell.top_level = true
		satyr_spell.get_node("AnimatedSprite2D").flip_h = animated_sprite_2d.flip_h
		satyr_spell.global_position.y = starting_pos
		starting_pos+=10
		#print("Add spell")
	
	
func stun_effect():
	pass

func update_animation():
	if last_dir.x > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	
	
