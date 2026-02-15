extends Node2D

var maxHealth 
var health = maxHealth # health is set to max when entity spawns/re spawns
@export var healthbar : Label = health # replace with ui box later

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func take_damage(damage):
	health -= damage
	healthbar.text = health
	if health<=0:
		get_parent().queue_free()
		
func heal(additional_health):
	health += additional_health
	healthbar.text = health
	if health > maxHealth:
		health = maxHealth
