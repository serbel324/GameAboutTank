extends Node2D
class_name Turret

enum State {
	ALIVE,
	DEAD
}

var rotation_speed : float = 1

var angular_speed : float = 0
var angle_to_target : float = 0

var state : State
var target : Vector2

func die():
	state = State.DEAD

func process_input():
	target = get_viewport().get_mouse_position()
	var position_on_canvas : Vector2 = get_global_transform_with_canvas().get_origin()
	var forward : Vector2 = global_transform.basis_xform(Vector2.RIGHT)
	var direction_to_target : Vector2 = target - position_on_canvas
	angle_to_target = forward.angle_to(direction_to_target)
	
	if (angle_to_target > 0):
		angular_speed = rotation_speed
	else:
		angular_speed = -rotation_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.ALIVE

func state_alive(delta : float):
	process_input()
	
	var delta_angle : float = angular_speed * delta
	if (delta_angle > 0 && angle_to_target > 0):
		delta_angle = minf(delta_angle, angle_to_target)
	elif (delta_angle < 0 && angle_to_target < 0):
		delta_angle = maxf(delta_angle, angle_to_target)
	rotate(delta_angle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.ALIVE:
			state_alive(delta)
		State.DEAD:
			pass
