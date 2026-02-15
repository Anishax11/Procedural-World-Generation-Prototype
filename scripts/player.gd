extends CharacterBody2D

var dream = "forest"
enum States{combat,explore}
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

func _ready():
	color_rect.color = worldshade[dream]["color"]
	color_rect.color.a = worldshade[dream]["opacity"]
	
func _physics_process(delta: float) -> void:
	#if state == States.combat:
		#return
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
