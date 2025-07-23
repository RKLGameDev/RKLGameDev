extends Node2D


@onready var times_of_day = MainRoomGlobal.times_of_day
@onready var time_of_day  = MainRoomGlobal.time_of_day

@onready var light_states = MainRoomGlobal.light_states
@onready var light_state  = MainRoomGlobal.light_state

func _on_area_2d_body_entered(_body: Node2D) -> void:
	time_of_day = times_of_day.day
	light_state = light_states.off
	var newscene = "res://Scenes/Location Scenes/Bedroom.tscn"
	get_tree().call_deferred("change_scene_to_file", newscene)
