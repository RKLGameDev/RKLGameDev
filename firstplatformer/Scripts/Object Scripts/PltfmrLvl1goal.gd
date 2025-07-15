extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	var newscene = "res://Scenes/Location Scenes/MorningBedroom.tscn"
	get_tree().call_deferred("change_scene_to_file", newscene)
