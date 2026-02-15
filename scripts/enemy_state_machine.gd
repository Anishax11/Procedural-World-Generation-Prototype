extends Area2D

var player
var distance_to_player
var parent 
var state 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while(parent == null):
		parent = get_parent()
	state = parent.States.patrol
	player = get_tree().current_scene.find_child("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if state == parent.States.patrol:
		parent.patrol()
	elif state == parent.States.chase:
		parent.navigation_agent_2d.target_position = player.global_position
		distance_to_player=position.distance_to(player.global_position)
		parent.chase()
	else:
		parent.combat()
		
	parent.move_and_slide()
	parent.wait_time-=delta

	



#func _on_range_body_exited(body: Node2D) -> void:
	#if body.name =="Player":
		#print("player out of sight")
		#state = parent.States.patrol


func _on_body_entered(body: CharacterBody2D) -> void:
	print("Body detected")
	if body.name =="Player":
		print("player in sight")
		state = parent.States.chase


func _on_body_exited(body: Node2D) -> void:
	if body.name =="Player":
		print("player out of sight")
		state = parent.States.patrol
