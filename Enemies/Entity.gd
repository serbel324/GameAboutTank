extends RigidBody2D
class_name Entity


enum Team {
	TANK,
	ENEMY
}

@export var max_health : int = 100
@export var team : Team = Team.ENEMY

enum State {
	ALIVE,
	DEAD
}

var state : State = State.ALIVE
var health : float = 0


func _init():
	health = max_health
	state = State.ALIVE


func spawn(pos: Vector2) -> void:
	if (pos != null):
		position = pos


func hit(damage_pts: int) -> void:
	health -= damage_pts
	if (health <= 0):
		health = 0
		state = State.DEAD
		die()


func is_enemy() -> bool:
	return team == Team.ENEMY

func die() -> void:
	queue_free()
