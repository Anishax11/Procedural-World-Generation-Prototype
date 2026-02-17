extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var greenery: Node2D = $Greenery


# FOREST :
const DECOR = preload("res://scenes/decor.tscn")
const TREE = preload("res://scenes/tree.tscn")
const STONES = preload("res://scenes/stones.tscn")
const ENEMY = preload("uid://ddjijj7jpne32")
#GraveYard :
const GRAVE = preload("uid://bj43j4g6rj2ct")
const STATUE = preload("uid://cw7m1fl852p2o")


var width = 50
var height = 30
var altitude ={}
var dream = "graveyard"
var forest_grass
var forest_shiny_grass
var color_rect

var worlds ={
	"forest" = {
	"layer0" : {"source" : 0, "cord" : Vector2i(8,1)},
	"layer1" : {"source" : 0, "cord" : Vector2i(8,1)},
	"layer2" : {"source" : 0, "cord" : Vector2i(8,0)},
	"layer3" : {"source" : 0, "cord" : Vector2i(8,0)},
	"color" : "3e23663d",
	"opacity" :0.2
},
"graveyard" = {
	"layer0" : {"source" : 2, "cord" : Vector2i(11,27)},
	"layer1" : {"source" : 2, "cord" : Vector2i(13,27)},
	"layer2" : {"source" : 2, "cord" : Vector2i(12,26)},
	"layer3" : {"source" : 2, "cord" : Vector2i(11,27)},
	"color" : "3e23663d",
	"opacity" :0.2}
	
}

var fast_noise = FastNoiseLite.new()

func world_generator(period,octave):
	fast_noise.seed = randf()
	fast_noise.frequency = period
	fast_noise.fractal_octaves = octave
	fast_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	
	var grid ={}
	for y in range(0,height):
		for x in range(0,width):
			#print("x,y :", Vector2(x,y))
			var random = abs(fast_noise.get_noise_2d(x,y))
			#print("random :",random)
			grid[Vector2i(x,y)] = random
	return grid
	
	
func _ready() -> void:
	color_rect = get_tree().current_scene.find_child("ColorRect")
	color_rect.color = worlds[dream]["color"]
	color_rect.color.a = worlds[dream]["opacity"]
	altitude = world_generator(300,5)
	set_tiles()
	spawn_enemy()
	
func set_tiles():
	for y in range(height):
		for x in range(width):
			if altitude[Vector2i(x,y)]<0.4:
				tile_map_layer.set_cell(Vector2(x,y),worlds[dream]["layer0"]["source"],worlds[dream]["layer0"]["cord"])
			elif altitude[Vector2i(x,y)]<0.5:
				tile_map_layer.set_cell(Vector2(x,y),worlds[dream]["layer1"]["source"],worlds[dream]["layer1"]["cord"])
				if dream == "forest" :
					spawn_stone(Vector2i(x,y))
				
				
			elif altitude[Vector2i(x,y)]<0.6:
				tile_map_layer.set_cell(Vector2(x,y),worlds[dream]["layer2"]["source"],worlds[dream]["layer2"]["cord"])
				if dream =="graveyard":
					spawn_grave(Vector2i(x,y))	
			elif altitude[Vector2i(x,y)]<0.7:
				
				spawn_decor(Vector2i(x,y))
				tile_map_layer.set_cell(Vector2(x,y),worlds[dream]["layer3"]["source"],worlds[dream]["layer3"]["cord"])
			
			
			else:
				tile_map_layer.set_cell(Vector2(x,y),worlds[dream]["layer0"]["source"],worlds[dream]["layer0"]["cord"])
				if dream == "forest" :
					spawn_tree(Vector2i(x,y))
				elif dream =="graveyard":
					spawn_statue(Vector2i(x,y))		
				
				

func spawn_tree(pos):
	var tree = TREE.instantiate()
	tree.global_position = tile_map_layer.map_to_local(pos)
	greenery.add_child(tree)

func spawn_stone(pos):
	if dream == "forest":
		var stone = STONES.instantiate()
		stone.global_position = tile_map_layer.map_to_local(pos)
		greenery.add_child(stone)
		
		
func spawn_grave(pos):
	var grave = GRAVE.instantiate()
	grave.global_position = tile_map_layer.map_to_local(pos)
	greenery.add_child(grave)

func spawn_decor(pos):
	var decor = DECOR.instantiate()
	decor.global_position = tile_map_layer.map_to_local(pos)
	greenery.add_child(decor)

func spawn_enemy():
	for i in range(30):
		var enemy = ENEMY.instantiate()
		enemy.global_position = Vector2(randi_range(0,width*15 ),randi_range(0,height*15))
		#print("Spawn point enemy :",enemy.global_position)
		add_child(enemy)

func spawn_statue(pos):
	var decor = STATUE.instantiate()
	decor.global_position = tile_map_layer.map_to_local(pos)
	greenery.add_child(decor)
