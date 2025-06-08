class_name Turret extends Node2D


enum State {
	ALIVE,
	DEAD
}

@export var camera_view_distance: float = 0.8
@export var rotation_speed: float = 1.0
@export var cannon_cooldown_sec: float = 3.0
@export var projectile_scene: PackedScene = null


var state: State = State.ALIVE
var angular_speed: float = 0.0
var cannon_reload: float = 0.0

var target: Vector2
var tank: TankController = null
var camera: Camera2D = null


func die() -> void:
	state = State.DEAD


func set_target(target_global: Vector2) -> void:
	target = target_global


func update_camera_position(shift: Vector2):
	camera.position = shift * camera_view_distance / camera.zoom + global_position


# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.ALIVE
	tank = get_node("/root/World/Tank") as TankController
	assert(tank != null)
	
	camera = get_node("/root/World/PlayerCamera") as Camera2D
	assert(camera != null)
	cannon_reload = 0.0


func reload_cannon(delta: float) -> void:
	cannon_reload = maxf(cannon_reload - delta, 0.0)


func rotate_to_target(delta: float) -> void:
	var forward: Vector2 = global_transform.basis_xform(Vector2.RIGHT)
	var direction_to_target: Vector2 = target - global_position
	var angle_to_target: float = forward.angle_to(direction_to_target)
	
	if (angle_to_target > 0):
		angular_speed = rotation_speed
	else:
		angular_speed = -rotation_speed
	
	var delta_angle: float = angular_speed * delta
	if (delta_angle > 0 && angle_to_target > 0):
		delta_angle = minf(delta_angle, angle_to_target)
	elif (delta_angle < 0 && angle_to_target < 0):
		delta_angle = maxf(delta_angle, angle_to_target)
	rotate(delta_angle)


func state_alive(delta: float) -> void:
	rotate_to_target(delta)
	reload_cannon(delta)


func state_dead(_delta: float) -> void:
	pass


func fire_cannon() -> void:
	if cannon_reload == 0.0:
		assert(projectile_scene != null)
		var projectile: Projectile = projectile_scene.instantiate() as Projectile
		projectile.launch(global_position, global_transform.basis_xform(Vector2.RIGHT), Entity.Team.TANK)
		get_tree().root.add_child(projectile)
		cannon_reload = cannon_cooldown_sec


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.ALIVE:
			state_alive(delta)
		State.DEAD:
			state_dead(delta)
