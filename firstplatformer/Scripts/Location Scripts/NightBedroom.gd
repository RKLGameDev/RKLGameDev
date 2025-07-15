extends Control

#@onready var player_scene = preload("res://Scenes/AwakePlayer.tscn") 

@onready var roomsprite = $TheRoom/RoomSprite
@onready var player = $TheRoom/AwakePlayer
var playerinbed = false

func _ready():
#	var player_instance = player_scene.instantiate()
#	add_child(player_instance)
	# Optionally set the player's position
#	player_instance.position = Vector2(384.0, 288.0) # Example position
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Location Scenes/PlatformerLvl1.tscn")
	pass # Replace with function body.

func _on_end_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_bed_body_entered(body: Node2D) -> void:
	print(body.name == "AwakePlayer")
	if body.name == "AwakePlayer":
		playerinbed = true

func _on_bed_body_exited(body: Node2D) -> void:
	playerinbed = false

func _physics_process(delta):
	if playerinbed and Input.is_action_just_pressed("jump"):
		roomsprite.frame = 2
		player.visible = false
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Location Scenes/PlatformerLvl1.tscn")
