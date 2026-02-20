extends Node2D

class_name HealthBoxComponent
@export var maxHealth : float
var health 
@export var healthbar : TextureRect
var bar_no = 10
var health_percent = 100 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthbar = get_node("TextureRect")
	health = maxHealth
	

func take_damage(damage):
	health -= damage
	if health<0:
		health =0
	update_health_bar()

func heal(additional_health):
	health += additional_health
	if health >= maxHealth:
		health = maxHealth
	else:
		update_health_bar()
		
func update_health_bar():
	#print("Updating health bar")
	var percent = health/maxHealth * 100
	if get_parent().name=="Player":
		print("Health :",health)
		print("Percent : ",percent)
	if percent <= health_percent - 10: # remove one bar when health falls by 10 percent
		var diff = health_percent - percent

		while(diff>=10):
			if healthbar.has_node("TextureRect"+str(bar_no)): 
				healthbar.get_node("TextureRect"+str(bar_no)).visible = false
				health_percent-=10
				bar_no -= 1
				diff-=10
	
	
	elif percent >= health_percent : # add one bar when health adds by 10 percent
		var diff = percent - health_percent 
		while(diff>=10):
			bar_no += 1
			health_percent+=10
			healthbar.get_node("TextureRect"+str(bar_no)).visible = true
			diff-=10
		
