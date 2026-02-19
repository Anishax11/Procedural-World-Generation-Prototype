extends Node2D

class_name HealthBoxComponent
@export var maxHealth : float
var health # health is set to max when entity spawns/re spawns
@export var healthbar : TextureRect
var bar_no = 10
const HEALTH = preload("uid://bri7y5xck3bbf")
var bar_position = 121
var health_percent = 100
var health_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = maxHealth
	health_reference = get_node("TextureRect/TextureRect1")

#func _process(delta: float) -> void:
	#if get_parent().name=="Satyr1":
		#print("Health 10 visible : ",healthbar.get_node("TextureRect10").visible)

func take_damage(damage):
	
	health -= damage
	update_health_bar()
		
		
func heal(additional_health):
	health += additional_health
	if health >= maxHealth:
		health = maxHealth
	else:
		update_health_bar()


func update_health_bar():
	var percent = health/maxHealth * 100
	if percent <= health_percent - 10: # remove one bar when health falls by 10 percent
		var diff = health_percent - percent
		while(diff>0):
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
		
