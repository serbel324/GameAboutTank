extends PickupBase

@export var turret_scene : PackedScene = null

@onready var tank : TankController = get_node("/root/World/Tank")

func picked() -> void:
	assert(turret_scene != null)
	tank.replace_turret(turret_scene)
	queue_free()
