extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	pass # Replace with function body.

func _on_end_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
