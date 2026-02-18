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
	print("Scale :",health_reference.scale)


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
		
		healthbar.get_node("TextureRect"+str(bar_no)).visible = false
		health_percent-=10
		bar_no -= 1
		if get_parent().name == "Player":
			print(percent)
			print(health_percent)
	elif percent >= health_percent : # add one bar when health adds by 10 percent
		bar_no += 1
		print(bar_no)
		healthbar.get_node("TextureRect"+str(bar_no)).visible = true
		if get_parent().name == "Player":
			print(percent)
			print(health_percent)
