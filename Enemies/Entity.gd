extends RigidBody2D
class_name Entity

@export var max_health : float = 100

enum State {
	ALIVE,
	DEAD
}

var state : State = State.ALIVE
var health : float = 0


func _init():
	health = max_health
	state = State.ALIVE


func spawn(pos : Vector2) -> void:
	if (pos != null):
		position = pos


func hit(damage : Damage) -> void:
	health -= damage.damage_pts
	if (health < 0):
		health = 0
		state = State.DEAD
		die()


func die() -> void:
	queue_free()
