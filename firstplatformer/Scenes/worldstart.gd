extends Node2D

#@onready var player_scene = preload("res://Scenes/Player.tscn") 
#
#func _ready():
#	var player_instance = player_scene.instantiate()
#	add_child(player_instance)
#	# Optionally set the player's position
#	player_instance.position = Vector2(378.0, 93.0) # Example position
@onready var player         = $Player

func _physics_process(delta):
	if player.health == 3:
		await get_tree().create_timer(4.0).timeout
		get_tree().change_scene_to_file("res://Scenes/NightMainMenu.tscn")
