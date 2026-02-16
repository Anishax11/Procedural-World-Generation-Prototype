extends Node2D

class_name HealthBoxComponent
@export var maxHealth : int
var health # health is set to max when entity spawns/re spawns
@export var healthbar : Label # replace with ui box later

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = maxHealth
	healthbar.text = str(maxHealth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func take_damage(damage):
	
	health -= damage
	healthbar.text = str(health)
	#if health<=0:
		#print("Entity dead")
		
		
func heal(additional_health):
	health += additional_health
	if health > maxHealth:
		health = maxHealth
	healthbar.text = str(health)
