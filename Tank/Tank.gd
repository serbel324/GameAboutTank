class_name TankController extends Node2D

enum State {
	ALIVE,
	DEAD
}



@export var hull_scene : PackedScene = preload("res://Tank/Modules/Hulls/IS3000.tscn")
@export var turret_scene : PackedScene = preload("res://Tank/Modules/Turrets/IS3000.tscn")

var turret : Turret = null
var hull : Hull = null

var state : State = State.ALIVE


# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.ALIVE
	
	hull = hull_scene.instantiate() as Hull
	assert(hull != null)

	turret = turret_scene.instantiate() as Turret
	assert(turret != null)

	var turret_socket : Node2D = hull.find_child("TurretSocket")
	assert(turret_socket != null)

	turret_socket.add_child(turret)
	add_child(hull)



func process_input() -> void:
	var forward_movement : float = Input.get_action_strength("move_forward")
	var backward_movement : float = Input.get_action_strength("move_backward")
	var left_turn : float = Input.get_action_strength("turn_left")
	var right_turn : float = Input.get_action_strength("turn_right")
	
	turret.set_target(get_global_mouse_position())

	if (forward_movement == 0 && backward_movement > 0):
		hull.add_linear_movement(-backward_movement)
		hull.add_rotation(left_turn - right_turn)
	else:
		hull.add_linear_movement(forward_movement)
		hull.add_rotation(right_turn - left_turn)

	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var screen_dimensions : Vector2 = get_viewport_rect().size
	turret.update_camera_position(mouse_pos - screen_dimensions / 2)


func state_alive(_delta : float) -> void:
	process_input()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.ALIVE:
			state_alive(delta)
		State.DEAD:
			pass


func get_hull() -> Hull:
	return hull
