extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var greenery: Node2D = $Greenery
const DECOR = preload("res://scenes/decor.tscn")
const TREE = preload("res://scenes/tree.tscn")
const STONES = preload("res://scenes/stones.tscn")
var width = 150
var height = 100
var altitude ={}
var dream = "forest"
var forest_grass
var forest_shiny_grass

var worlds ={
	"forest" = {
	"layer0" : Vector2i(8,1),
	"layer1" : Vector2i(8,1),
	"layer2" : Vector2i(8,0),
	"layer3" : Vector2i(8,0)
	
}
	
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
	altitude = world_generator(300,5)
	set_tiles()
	
func set_tiles():
	for y in range(height):
		for x in range(width):
			if altitude[Vector2i(x,y)]<0.4:
				tile_map_layer.set_cell(Vector2(x,y),0,worlds[dream]["layer0"])
			elif altitude[Vector2i(x,y)]<0.5:
				tile_map_layer.set_cell(Vector2(x,y),0,worlds[dream]["layer1"])
				if dream == "forest":
					spawn_stone(Vector2i(x,y))
			elif altitude[Vector2i(x,y)]<0.6:
				tile_map_layer.set_cell(Vector2(x,y),0,worlds[dream]["layer2"])
				
			elif altitude[Vector2i(x,y)]<0.7:
				if dream == "forest":
					spawn_decor(Vector2i(x,y))
				tile_map_layer.set_cell(Vector2(x,y),0,worlds[dream]["layer3"])
			else:
				tile_map_layer.set_cell(Vector2(x,y),0,worlds[dream]["layer0"])
				if dream == "forest":
					spawn_tree(Vector2i(x,y))
				

func spawn_tree(pos):
	var tree = TREE.instantiate()
	tree.global_position = tile_map_layer.map_to_local(pos)
	greenery.add_child(tree)

func spawn_stone(pos):
	var stone = STONES.instantiate()
	stone.global_position = tile_map_layer.map_to_local(pos)
	greenery.add_child(stone)

func spawn_decor(pos):
	var decor = DECOR.instantiate()
	decor.global_position = tile_map_layer.map_to_local(pos)
	greenery.add_child(decor)
