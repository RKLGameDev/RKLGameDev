extends Node2D

@onready var lssprite = $LightSwitch/LSSprite
@onready var fssprite = $FanSwitch/FSSprite

var lssframes = {"on":1, "off":4}
var fssframes = {"on":2, "off":5}

@onready var fan_states = MainRoomGlobal.fan_states
@onready var light_states = MainRoomGlobal.light_states

func _ready():
	if MainRoomGlobal.light_state == light_states.on:
		lssprite.frame = lssframes["on"]
	if MainRoomGlobal.light_state == light_states.off:
		lssprite.frame = lssframes["off"]
		
	if MainRoomGlobal.fan_state == fan_states.on:
		fssprite.frame = fssframes["on"]
	if MainRoomGlobal.fan_state == fan_states.off:
		fssprite.frame = fssframes["off"]

@warning_ignore("unused_parameter")
func _on_light_switch_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		MainRoomGlobal.global_property_change = true
		
		if MainRoomGlobal.light_state == light_states.on:
			MainRoomGlobal.light_state = light_states.off
			lssprite.frame = lssframes["off"]
			return
		if MainRoomGlobal.light_state == light_states.off:
			MainRoomGlobal.light_state = light_states.on
			lssprite.frame = lssframes["on"]
			return

@warning_ignore("unused_parameter")
func _on_fan_switch_input_event(viewport: Node,  event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if MainRoomGlobal.fan_state == fan_states.on:
			MainRoomGlobal.fan_state = fan_states.off
			fssprite.frame = fssframes["off"]
			return
		if MainRoomGlobal.fan_state == fan_states.off:
			MainRoomGlobal.fan_state = fan_states.on
			fssprite.frame = fssframes["on"]
			return
