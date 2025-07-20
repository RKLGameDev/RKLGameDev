extends Node2D

@onready var doorsprite = $AnimatedSprite2D


@warning_ignore("unused_parameter")
func _on_open_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if doorsprite.frame == 8:
			doorsprite.play_backwards()


@warning_ignore("unused_parameter")
func _on_closed_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if doorsprite.frame == 0:
			doorsprite.play()
