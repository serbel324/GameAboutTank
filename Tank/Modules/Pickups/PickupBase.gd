class_name PickupBase extends Area2D

func picked() -> void:
	queue_free()

func _on_body_entered(body : Node) -> void:
	# doesn't work with newly instantiated objects for some reason, investigate
	if body is Hull:
		picked()
	
func _physics_process(_delta : float) -> void:
	# TODO: fix body entering detection
	var hull : Hull = get_node("/root/World/Tank/Hull")
	var delta : float = (hull.global_position - global_position).length()
	if delta < 30:
		picked()
