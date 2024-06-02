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


func _ready():
	assert(map_size.x > 0 && map_size.y > 0)
	volume = map_size.x * map_size.y
	map.resize(volume)
	
	assert(tile_set != null)
	tile_set_source_id = tile_set.get_source_id(0)

	for y in map_size.y:
		for x in map_size.x:
			var cell_type : Cell = Cell.GRASS

			if (y == 0 || y == map_size.y - 1 || x == 0 || x == map_size.x - 1):
				cell_type = Cell.STONE
			else:
				cell_type = randi() % Cell.COUNT as Cell
			
			set_cell_by_coords(Vector2i(x, y), cell_type)
			var atlas_coord : Vector2i = Vector2i(cell_type, 0)
			set_cell(0, Vector2i(x, y), tile_set_source_id, atlas_coord)
