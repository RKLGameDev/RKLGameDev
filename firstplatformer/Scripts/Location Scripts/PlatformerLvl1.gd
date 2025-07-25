extends Node2D

#@onready var player_scene = preload("res://Scenes/Player.tscn") 
#
#func _ready():
#	var player_instance = player_scene.instantiate()
#	add_child(player_instance)
#	# Optionally set the player's position
#	player_instance.position = Vector2(378.0, 93.0) # Example position
@onready var player         = $Player

@onready var times_of_day = MainRoomGlobal.times_of_day
@onready var time_of_day  = MainRoomGlobal.time_of_day

@onready var light_states = MainRoomGlobal.light_states
@onready var light_state  = MainRoomGlobal.light_state

func _physics_process(_delta):
	if player.health == 0:
		await get_tree().create_timer(4.0).timeout
		MainRoomGlobal.time_of_day = times_of_day.latenight
		MainRoomGlobal.light_state = light_states.off
		get_tree().change_scene_to_file("res://Scenes/Location Scenes/Bedroom.tscn")
		
		
