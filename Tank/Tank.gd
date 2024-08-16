class_name TankController extends Node2D

enum State {
	ALIVE,
	DEAD
}


@export var hull_scene: PackedScene = preload("res://Tank/Modules/Hulls/IS3000.tscn")
@export var turret_scene: PackedScene = preload("res://Tank/Modules/Turrets/IS3000.tscn")

var turret: Turret = null
var hull: Hull = null

var state: State = State.ALIVE


# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.ALIVE
	
	hull = hull_scene.instantiate() as Hull
	assert(hull != null)

	turret = turret_scene.instantiate() as Turret
	assert(turret != null)

	var turret_socket: Node2D = hull.find_child("TurretSocket")
	assert(turret_socket != null)

	turret_socket.add_child(turret)
	add_child(hull)


func process_input() -> void:
	var forward_movement: float = Input.get_action_strength("move_forward")
	var backward_movement: float = Input.get_action_strength("move_backward")
	var left_turn: float = Input.get_action_strength("turn_left")
	var right_turn: float = Input.get_action_strength("turn_right")

	turret.set_target(get_global_mouse_position())

	if (forward_movement == 0 && backward_movement > 0):
		hull.add_linear_movement(-backward_movement)
		hull.add_rotation(left_turn - right_turn)
	else:
		hull.add_linear_movement(forward_movement)
		hull.add_rotation(right_turn - left_turn)

	var vp_rect: Rect2 = get_viewport_rect()
	var vp_rect_center: Vector2 = vp_rect.get_center()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()

	if not vp_rect.has_point(mouse_pos): # mouse out of window check
		var view_direction: Vector2 = mouse_pos - vp_rect_center
		var tan_view: float = abs(view_direction.y / view_direction.x)
		if tan_view > vp_rect_center.y / vp_rect_center.x: # top/bottom
			mouse_pos = vp_rect_center + Vector2(vp_rect_center.y / tan_view, vp_rect_center.y) * sign(view_direction)
		else: # left/right
			mouse_pos = vp_rect_center + Vector2(vp_rect_center.x, vp_rect_center.x * tan_view) * sign(view_direction)

	turret.update_camera_position(mouse_pos - vp_rect_center)


func state_alive(_delta: float) -> void:
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
