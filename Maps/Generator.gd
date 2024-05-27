extends TileMap

enum Cell {
	FOREST = 0,
	GRASS,
	SAND,
	STONE,
	COUNT
}

@export var map_size : Vector2i
var tile_set_source_id : int = 0xdead

func _ready():
	assert(map_size.x > 0 && map_size.y > 0)
	
	assert(tile_set != null)
	tile_set_source_id = tile_set.get_source_id(0)

	for y in map_size.y:
		for x in map_size.x:
			var cell_type : Cell = Cell.GRASS

			if (y == 0 || y == map_size.y - 1 || x == 0 || x == map_size.x - 1):
				cell_type = Cell.STONE
			else:
				cell_type = randi() % Cell.COUNT as Cell
			var atlas_coord : Vector2i = Vector2i(cell_type, 0)
			set_cell(0, Vector2i(x, y), tile_set_source_id, atlas_coord)

