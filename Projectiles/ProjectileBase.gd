class_name Projectile extends Area2D

@export var start_speed: float = 1000
@export var max_distance: float = 1000
@export var damage_pts: int = 50

var direction: Vector2 = Vector2.ZERO
var traveled: float = 0
var speed: float = 0

var alive: bool = true
var team: Entity.Team


# Called when the node enters the scene tree for the first time.
func _ready():
	# Подключаем сигнал столкновения
	body_entered.connect(_on_body_entered)


func launch(global_position_: Vector2, direction_: Vector2, team_: Entity.Team) -> void:
	team = team_
	assert(global_position_ != null)
	assert(direction_ != null)
	speed = start_speed
	global_position = global_position_
	direction = direction_.normalized()
	rotate(direction.angle())
	traveled = 0


func hit(target: Entity) -> void:
	if !alive:
		return # race occured

	if target.team == team:
		return

	target.hit(damage_pts)
	alive = false


func terminate() -> void:
	alive = false
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !alive:
		return
		
	traveled += speed * delta
	global_position += direction * speed * delta

	if (traveled > max_distance):
		terminate()


func _on_body_entered(body : Node) -> void:
	if !alive:
		return
	
	if body is TileMap:
		terminate()
		return
	
	if body is Entity and body.team != team:
		hit(body)
		terminate()
		return
