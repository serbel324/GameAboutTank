extends TileMap
class_name Ground

enum Cell {
	FOREST = 0,
	GRASS,
	SAND,
	STONE,
	COUNT
}

@export var map_size : Vector2i

var tile_set_source_id : int = 0xdead
var volume : int
var map : Array[Cell]


func get_map_volume() -> int:
	return volume


func get_cell_by_coords(coords : Vector2i) -> Cell:
	return get_cell_by_idx(coords.y * map_size.x + coords.x)


func get_cell_by_idx(idx : int) -> Cell:
	assert(idx < volume)
	return map[idx]


func set_cell_by_coords(coords : Vector2i, cell : Cell) -> void:
	set_cell_by_idx(coords.y * map_size.x + coords.x, cell)


func set_cell_by_idx(idx : int, cell : Cell) -> void:
	map[idx] = cell


func get_cell_global_coords(tile : Vector2i) -> Vector2:
	return to_global(map_to_local(tile))


func resize_map() -> void:
	assert(map_size.x > 0 && map_size.y > 0)
	volume = map_size.x * map_size.y
	map.resize(volume) 


func reassign_tiles() -> void:
	tile_set_source_id = tile_set.get_source_id(0)
	for y in map_size.y:
		for x in map_size.x:
			var cell_type : Cell = get_cell_by_coords(Vector2i(x, y))
			var atlas_coord : Vector2i = Vector2i(cell_type, 0)
			set_cell(0, Vector2i(x, y), tile_set_source_id, atlas_coord)


func noise_generator() -> void:
	assert(tile_set != null)

	for y in map_size.y:
		for x in map_size.x:
			var cell_type : Cell = Cell.GRASS

			if (y == 0 || y == map_size.y - 1 || x == 0 || x == map_size.x - 1):
				cell_type = Cell.STONE
			else:
				cell_type = randi() % Cell.COUNT as Cell

			set_cell_by_coords(Vector2i(x, y), cell_type)


func perlin_generator() -> void:
	var mountain_barrier = 0.0
	var mountain_transformer : Callable = func(x) :
		if x > mountain_barrier:
			return 1
		else:
			return 0
	var mountain_noise : PerlinNoise = PerlinNoise.new(6, Vector2i(4, 4), map_size.x / 4,
			[60, 30, 10, 5, 2, 1], mountain_transformer)

	var cave_barrier = 0.03
	var cave_transformer : Callable = func(x : float) :
		if abs(x) < cave_barrier:
			return 1
		else:
			return 0
	var cave_noise : PerlinNoise = PerlinNoise.new(6, Vector2i(2, 2), map_size.x / 2,
			[60, 30, 10, 5, 2, 1], cave_transformer)

	cave_noise.generate()
	mountain_noise.generate()
	
	for y in map_size.y:
		for x in map_size.x:
			var cell_type : Cell = Cell.GRASS

			if (y == 0 || y == map_size.y - 1 || x == 0 || x == map_size.x - 1):
				cell_type = Cell.STONE
			else:
				var point = Vector2(x, y)
				if mountain_noise.value(point) > 0:
					if cave_noise.value(point) > 0:
						cell_type = Cell.SAND 
					else:
						cell_type = Cell.STONE

			set_cell_by_coords(Vector2i(x, y), cell_type)


func regenerate() -> void:
	resize_map()
	perlin_generator()
	reassign_tiles()


func _ready() -> void:
	regenerate()
	
func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("regenerate_map"):
		regenerate()
