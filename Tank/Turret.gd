extends Node2D

enum State {
	ALIVE,
	DEAD
}

@export var rotation_speed : float = 1

var angular_speed : float = 0

var state : State
var target : Vector2

func die():
	state = State.DEAD

func process_input():
	target = get_viewport().get_mouse_position()
	var position_on_canvas : Vector2 = get_global_transform_with_canvas().get_origin()
	var forward : Vector2 = global_transform.basis_xform(Vector2.RIGHT)
	var direction_to_target : Vector2 = target - position_on_canvas
	
	if (forward.cross(direction_to_target) < 0):
		angular_speed = rotation_speed
	else:
		angular_speed = -rotation_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.ALIVE

func state_alive(delta : float):
	process_input()
	rotate(angular_speed * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.ALIVE:
			state_alive(delta)
		State.DEAD:
			pass
