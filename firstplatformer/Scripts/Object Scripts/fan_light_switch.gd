extends Node2D

@onready var lssprite = $LightSwitch/LSSprite
@onready var fssprite = $LightSwitch/FSSprite

@onready var fan_states = MainRoomGlobal.fan_states
@onready var light_states = MainRoomGlobal.light_states

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


func _on_light_switch_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		MainRoomGlobal.light_state = light_states.on


func _on_fan_switch_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
	pass # Replace with function body.
