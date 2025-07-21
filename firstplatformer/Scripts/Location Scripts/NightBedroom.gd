extends Control

#@onready var player_scene = preload("res://Scenes/AwakePlayer.tscn") 

@onready var roomsprite = $TheRoom/RoomSprite
@onready var player = $TheRoom/CommonBedroomAssets/AwakePlayer
var playerinbed = false

func _ready():
	roomsprite.frame = 4
	player.hide()
	await get_tree().create_timer(2.0).timeout
	roomsprite.frame = 5
	player.show()


func _physics_process(delta):
	if playerinbed and Input.is_action_just_pressed("jump"):
		roomsprite.frame = 0
		player.visible = false
		await get_tree().create_timer(3.0).timeout
		GlobalLevelTracker.level_start()


func _on_bed_mm_body_entered(body: Node2D) -> void:
	if body.name == "AwakePlayer":
		playerinbed = true
		print("In Bed")



func _on_bed_mm_body_exited(body: Node2D) -> void:
	playerinbed = false
