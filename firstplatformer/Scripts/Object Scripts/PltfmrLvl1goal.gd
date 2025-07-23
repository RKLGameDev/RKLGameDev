extends Node2D


@onready var times_of_day = MainRoomGlobal.times_of_day
@onready var light_states = MainRoomGlobal.light_states

func _on_area_2d_body_entered(_body: Node2D) -> void:
	MainRoomGlobal.time_of_day = times_of_day.day
	MainRoomGlobal.light_state = light_states.off
	var newscene = "res://Scenes/Location Scenes/Bedroom.tscn"
	get_tree().call_deferred("change_scene_to_file", newscene)
