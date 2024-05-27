extends RigidBody2D

enum State {
	ALIVE,
	DEAD
}

@export var backward_movement_speed : float = 30.0
@export var forward_movement_speed : float = 100.0
@export var hull_rotation_speed : float = 3.0
@export var turret_position : Vector2 = Vector2.ZERO
@export var camera_view_distance : float = 0.3
@export var turret_rotation_speed : float = 1.0

@export var turret_scene: PackedScene = preload("res://Tank/Turret.tscn")

var linear_movement : float = 0
var angular_movement : float = 0
var state : State
var camera : Node2D = null
var turret_socket : Node2D = null


# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.ALIVE

	turret_socket = find_child("TurretSocket")
	assert(turret_socket != null)
	turret_socket.position = turret_position
	var turret : Turret = turret_scene.instantiate() as Turret
	turret.rotation_speed = turret_rotation_speed
	turret_socket.add_child(turret)

	camera = get_parent().find_child("PlayerCamera")
	assert(camera != null)


func process_input():
	var forward_movement : float = Input.get_action_strength("move_forward")
	var backward_movement : float = Input.get_action_strength("move_backward")
	var left_turn : float = Input.get_action_strength("turn_left")
	var right_turn : float = Input.get_action_strength("turn_right")

	if (forward_movement < 0.1):
		linear_movement = backward_movement * -backward_movement_speed
		angular_movement = (left_turn - right_turn) * hull_rotation_speed
	else:
		linear_movement = forward_movement * forward_movement_speed
		angular_movement = (right_turn - left_turn) * hull_rotation_speed
	
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var screen_dimensions : Vector2 = get_viewport_rect().size
	camera.position = (mouse_pos - screen_dimensions / 2) * camera_view_distance + position


func state_alive(_delta : float):
	process_input()


func _integrate_forces(physics_state : PhysicsDirectBodyState2D):
	var direction : Vector2 = global_transform.basis_xform(Vector2.RIGHT)
	physics_state.linear_velocity = direction * linear_movement
	physics_state.angular_velocity = angular_movement

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.ALIVE:
			state_alive(delta)
		State.DEAD:
			pass
