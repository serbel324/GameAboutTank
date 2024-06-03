extends Entity

@export var speed = 1

var target : Node2D = null
var linear_movement : Vector2 = Vector2(0, 0)
var direction : Vector2 = Vector2.RIGHT


# Called when the node enters the scene tree for the first time.
func _ready():
	var tank : TankController = get_node("/root/World/Tank") as TankController
	target = tank.get_hull()


func state_alive(_delta : float) -> void:
	if (target != null):
		direction = (target.global_position - global_position).normalized()
		linear_movement = direction * speed
	else:
		direction = Vector2.RIGHT
		linear_movement = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	match state:
		State.ALIVE:
			state_alive(delta)
		State.DEAD:
			queue_free()


func _integrate_forces(physics_state : PhysicsDirectBodyState2D):
	physics_state.linear_velocity = linear_movement
	rotation = Vector2.RIGHT.angle_to(direction)
