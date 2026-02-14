extends Node2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var width = 500
var height = 500

var altitude ={}
var fast_noise = FastNoiseLite.new()

func world_generator(period,octave):
	fast_noise.seed = randf()
	fast_noise.frequency = period
	fast_noise.fractal_octaves = octave
	var grid ={}
	for y in range(height):
		for x in range(width):
			var random = fast_noise.get_noise_2d(x,y)
			grid[Vector2i(x,y)] = random
	return grid
	
	
func _ready() -> void:
	altitude = world_generator(300,5)
	set_tiles()
	
func set_tiles():
	for y in range(height):
		for x in range(width):
			if altitude[Vector2i(x,y)]<0.5:
				tile_map_layer.set_cell(Vector2i(x,y),0,Vector2i(24,1))
				print("Spawn water at :",Vector2(x,y))
			else:
				tile_map_layer.set_cell(altitude[Vector2i(x,y)],0,Vector2i(9,0))
				print("Spawn grass at :",Vector2(x,y))
