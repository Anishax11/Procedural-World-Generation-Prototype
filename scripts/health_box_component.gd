extends Node2D

class_name HealthBoxComponent
var maxHealth : float
var health 
@export var healthbar : TextureRect
var bar_no = 10
var health_percent = 100 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Health box ready")
	healthbar = get_node("TextureRect")
	if healthbar==null:
		print("healthbar null")
	maxHealth = 200
	health = maxHealth # health is set to max when entity spawns/re spawns
	print("Max health : ",maxHealth)
	print(" health : ",health)


func take_damage(damage):
	print("Take damage called : ",damage)
	health -= damage
	if health<0:
		health =0
	update_health_bar()
	if get_parent().name == "Satyr1":
			print("Health : ",health )
			print("Health percent : ",health_percent)
		
func heal(additional_health):
	health += additional_health
	if health >= maxHealth:
		health = maxHealth
	else:
		update_health_bar()
		if get_parent().name == "Satyr1":
			print("Health : ",health )	
			print("Health percent : ",health_percent)


func update_health_bar():
	print("Updating health bar")
	var percent = health/maxHealth * 100
	if percent <= health_percent - 10: # remove one bar when health falls by 10 percent
		var diff = health_percent - percent
		print("Health Percent : ",health_percent)
		print("Percent : ",percent)
		print("diff : ",diff)
		while(diff>0):
			if healthbar.has_node("TextureRect"+str(bar_no)): 
				print("Remove on ebar of health")
				healthbar.get_node("TextureRect"+str(bar_no)).visible = false
				health_percent-=10
				bar_no -= 1
				diff-=10
	
	
	elif percent >= health_percent : # add one bar when health adds by 10 percent
		var diff = percent - health_percent 
		print("diff : ",diff)
		while(diff>=10):
			bar_no += 1
			health_percent+=10
			print("Heal : ","TextureRect"+str(bar_no))
			healthbar.get_node("TextureRect"+str(bar_no)).visible = true
			diff-=10
		
	print("Updating health bar complete")
