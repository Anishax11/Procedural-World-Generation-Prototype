extends Node

var dream 
var dreams = ["forest","iceworld","graveyard"]
var enemies_left = 30
var base_attack_damage = 10.0 # player
var maxHealth = 100.0  # player
var level = 1.0 # keep track of worlds traversed, scale enemy and player damage/health with it

func _ready() -> void:
	dream = dreams[randi_range(0,2)]
	dreams.erase(dream)
