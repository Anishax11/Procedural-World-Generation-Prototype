extends Node

var dream 
var dreams = ["forest","iceworld","graveyard"]
var enemies_left = 30
var base_attack_damage = 10.0 # player
var maxHealth = 100.0  # player
var level = 1.0 # keep track of worlds traversed, scale enemy and player damage/health with it
var player_abilities : Array = []
var skeleton_wizards_to_kill = 3 #killing 3 gives ice spell
var watchers_to_kill = 5 #killing 5 gives shockwave/explosion spell
var satyrs_to_kill = 3
var bats_to_kill = 1
var message_label

func _ready() -> void:
	start_game()

func start_game():
	dream = dreams[randi_range(0,2)]
	dreams.erase(dream)		

func add_ability(ability):
	message_label = get_tree().current_scene.find_child("Message") 
	print("Adding new ability")
	player_abilities.append(ability)
	print(player_abilities)
	message_label.text = "New ability"
	await get_tree().create_timer(5).timeout
	if message_label.text == "New ability":
		message_label.text = ""
