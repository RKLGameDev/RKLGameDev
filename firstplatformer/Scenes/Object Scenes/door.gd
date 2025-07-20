extends Node2D


@warning_ignore("unused_parameter")
func _on_pot_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if amount_of_coffee > 0:
			amount_of_coffee = amount_of_coffee - 1


func _on_open_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
