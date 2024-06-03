class_name Hull extends Entity


@export var backward_movement_speed : float = 30.0
@export var forward_movement_speed : float = 100.0
@export var hull_rotation_speed : float = 3.0

var linear_movement : float = 0
var angular_movement : float = 0

var tank : TankController


func add_linear_movement(value : float) -> void:
	if (value < 0):
		linear_movement = value * backward_movement_speed
	else:
		linear_movement = value * forward_movement_speed


func add_rotation(value : float) -> void:
	angular_movement = value * hull_rotation_speed


func _integrate_forces(physics_state : PhysicsDirectBodyState2D):
	var direction : Vector2 = global_transform.basis_xform(Vector2.RIGHT)
	physics_state.linear_velocity = direction * linear_movement
	physics_state.angular_velocity = angular_movement
