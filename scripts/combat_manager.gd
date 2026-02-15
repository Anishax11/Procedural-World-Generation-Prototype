#extends Node2D
#
#var turn_queueu : Array = []
#var turn_index = 0
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if !turn_queueu.is_empty():
		#for e in turn_queueu:
			#e.turn = false
		#turn_queueu[turn_index].turn = true
		#turn_queueu[turn_index].state = true
		#turn_index+=1
		#
	#print("queue empty")
