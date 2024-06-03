class_name Turret extends Node2D


enum State {
	ALIVE,
	DEAD
}

@export var camera_view_distance : float = 0.3
@export var rotation_speed : float = 1.0

var state : State = State.ALIVE
var angular_speed : float = 0

var target : Vector2
var tank : TankController = null
var camera : Node2D = null


func die() -> void:
	state = State.DEAD


func set_target(target_global : Vector2) -> void:
	target = target_global


func update_camera_position(shift : Vector2):
	camera.position = shift * camera_view_distance + global_position


# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.ALIVE
	tank = get_node("/root/World/Tank") as TankController
	assert(tank != null)
	
	camera = get_node("/root/World/PlayerCamera")
	assert(camera != null)


func rotate_to_target(delta : float) -> void:
	var forward : Vector2 = global_transform.basis_xform(Vector2.RIGHT)
	var direction_to_target : Vector2 = target - global_position
	var angle_to_target : float = forward.angle_to(direction_to_target)
	
	if (angle_to_target > 0):
		angular_speed = rotation_speed
	else:
		angular_speed = -rotation_speed
	
	var delta_angle : float = angular_speed * delta
	if (delta_angle > 0 && angle_to_target > 0):
		delta_angle = minf(delta_angle, angle_to_target)
	elif (delta_angle < 0 && angle_to_target < 0):
		delta_angle = maxf(delta_angle, angle_to_target)
	rotate(delta_angle)
	

func state_alive(delta : float) -> void:
	rotate_to_target(delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.ALIVE:
			state_alive(delta)
		State.DEAD:
			pass
