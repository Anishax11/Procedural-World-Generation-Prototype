extends Area2D

var player
var distance_to_player
var parent 
enum States {patrol,chase,combat}
var state = States.patrol
var resolve_collision_time = 0.0# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while(parent == null):
		parent = get_parent()
	
	player = get_tree().current_scene.find_child("Player")
	parent.player = player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if resolve_collision_time > 0:
		parent.velocity = parent.direction * parent.speed
		parent.move_and_slide()
		resolve_collision_time-=delta
		return
		
	distance_to_player=parent.position.distance_to(player.position)
	if state == States.patrol:
		parent.patrol()
	elif state == States.chase:
		parent.navigation_agent_2d.target_position = player.global_position
		if distance_to_player <=8:
			state = States.combat
		parent.chase()
	elif state == States.combat:
		#print("Go to combat mode")
		parent.combat()
		
	parent.velocity = parent.speed*parent.direction
	parent.move_and_slide()
	parent.wait_time-=delta

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name =="Player":
		state = States.chase


func _on_body_exited(body: CharacterBody2D) -> void:
	if body.name =="Player":
		state = States.patrol
