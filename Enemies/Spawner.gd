extends Node
class_name Spawner

@export var spawn_delay_sec : float = 1
@export var ground : Ground = null

@export var zombie_scene : PackedScene

var timer : float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = spawn_delay_sec
	if (ground == null):
		ground = get_parent().find_child("Ground")
	assert(ground != null)
	assert(zombie_scene != null)


func try_to_spawn_in_random_location(tries : int):
	for i in tries:
		var cell_x : int = randi_range(0, ground.map_size.x - 1)
		var cell_y : int = randi_range(0, ground.map_size.y - 1)
		var cell_coords : Vector2i = Vector2i(cell_x, cell_y)
		var cell : Ground.Cell = ground.get_cell_by_coords(cell_coords)
		if (cell != Ground.Cell.STONE):
			var pos : Vector2 = ground.get_cell_global_coords(cell_coords)
			var new_zombie : Entity = zombie_scene.instantiate() as Entity
			new_zombie.spawn(pos)
			get_parent().add_child(new_zombie)
			return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	timer -= delta
	if (timer <= 0):
		timer = spawn_delay_sec
		try_to_spawn_in_random_location(10)
