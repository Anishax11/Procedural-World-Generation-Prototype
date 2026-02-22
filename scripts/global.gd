extends Node

var dream 
var dreams = ["forest","iceworld","graveyard"]
var enemies_left = 31
var base_attack_damage = 10.0 # player
var maxHealth = 100.0  # player
var level = 1.0 # keep track of worlds traversed, scale enemy and player damage/health with it
var player_abilities : Array = []
var skeleton_wizards_to_kill = 3 #killing 3 gives ice spell
var ghosts_to_kill = 5 #killing 5 gives shockwave/explosion spell
var satyrs_to_kill = 3
var bats_to_kill = 7
var dark_enemy_to_kill = 1
var message_label

var ability_desc = {
	"sound_wave" = "Echoburst unlocked. Press [0] to unleash a wave of pure sound that stuns enemies.",
	"ice_spell" = "Glacial Grasp unlocked. Press [9] to surge frozen energy outward.",
	"shock_wave" = "Pyre Ring unlocked. Press [8] to ignite a ring of fire that expands outward",
	"satyr_spell" = "Satyr's spell unlocked. Press [7] to unleash primal forest magic.",
	"dark_spell" = "Wraithstrike unlocked. Press [6] to strike with shadow itself."
}
func _ready() -> void:
	start_game()

func start_game():
	dream = dreams[randi_range(0,2)]
	dreams.erase(dream)		

func add_ability(ability):
	if GlobalCanvasLayer.switching_worlds:
		return
	if !player_abilities.has(ability):
		message_label = get_tree().current_scene.find_child("Message") 
		player_abilities.append(ability)
		print(player_abilities)
		message_label.text = ability_desc[ability]
		await get_tree().create_timer(5).timeout
		if message_label.text == ability_desc[ability]:
			message_label.text = ""
