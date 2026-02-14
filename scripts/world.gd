extends Node2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
const TREE = preload("res://scenes/tree.tscn")
var width = 150
var height = 100
var altitude ={}
#var forest ={
	#""
#}
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
				tile_map_layer.set_cell(Vector2(x,y),0,Vector2i(8,1))
			elif altitude[Vector2i(x,y)]<0.7:
				tile_map_layer.set_cell(Vector2(x,y),0,Vector2i(8,0))	
				
			else:
				spawn_tree(Vector2i(x,y))
				tile_map_layer.set_cell(Vector2(x,y),0,Vector2i(8,1))	
				

func spawn_tree(pos):
	var tree = TREE.instantiate()
	tree.global_position = tile_map_layer.map_to_local(pos)
	add_child(tree)
