extends RigidBody2D

enum State {
	ALIVE,
	DEAD
}

@export var forward_movement_speed : float = 100.0
@export var backward_movement_speed : float = 30.0
@export var hull_rotation_speed : float = 3.0
@export var turret_position : Vector2 = Vector2.ZERO

@export var turret_scene: PackedScene = preload(
		"res://Tank/Turret.tscn")

var linear_movement : float = 0
var angular_movement : float = 0

var physics_state : PhysicsDirectBodyState2D

var state : State

# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.ALIVE
	physics_state = PhysicsDirectBodyState2DExtension.new()
	var turret_socket : Node2D = find_child("TurretSocket")
	turret_socket.position = turret_position
	turret_socket.add_child(turret_scene.instantiate())
	

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
	


func state_alive(delta : float):
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
