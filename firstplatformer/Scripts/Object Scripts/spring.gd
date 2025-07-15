extends Area2D



func _on_body_entered(body: Node2D) -> void:
	var player = get_node("/root/World/Player")
	player.can_dblejump = true
	player.damaged = true
	queue_free()
	
