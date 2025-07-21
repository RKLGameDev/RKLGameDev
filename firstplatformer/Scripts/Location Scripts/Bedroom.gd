extends Control

#@onready var player_scene = preload("res://Scenes/AwakePlayer.tscn") 

@onready var roomsprite     = $TheRoom/RoomSprite
@onready var outsidesprite  = $TheRoom/OutsideSprite
@onready var lightingsprite = $TheRoom/LightingSprite
@onready var trdcharsprite  = $TheRoom/TiredChar
@onready var sleepingsprite = $TheRoom/SleepingChar
@onready var player         = $TheRoom/CommonBedroomAssets/AwakePlayer

@onready var times_of_day = MainRoomGlobal.times_of_day
@onready var time_of_day  = MainRoomGlobal.time_of_day

@onready var light_states = MainRoomGlobal.light_states
@onready var light_state  = MainRoomGlobal.light_state

var playerinbed = false

func _ready():
	
	if time_of_day == times_of_day.sunset:
		outsidesprite.frame = 0
		if light_state == light_states.on:
			lightingsprite.frame = 0
		if light_state == light_states.off:
			lightingsprite.frame = 1
			
	if time_of_day == times_of_day.day:
		outsidesprite.frame = 1
		if light_state == light_states.on:
			lightingsprite.frame = 2
		if light_state == light_states.off:
			lightingsprite.frame = 3
			
	if time_of_day == times_of_day.night:
		outsidesprite.frame = 2
		if light_state == light_states.on:
			lightingsprite.frame = 4
		if light_state == light_states.off:
			lightingsprite.frame = 5
			trdcharsprite
			
			
		
		
	if time_of_day == times_of_day.night:
		player.hide()
		trdcharsprite.show()
		await get_tree().create_timer(2.0).timeout
		trdcharsprite.hide()
		player.show()
	else:
		trdcharsprite.hide()
	
	if time_of_day == times_of_day.day:
		player.hide()
		sleepingsprite.show()
		await get_tree().create_timer(2.0).timeout
		sleepingsprite.hide()
		player.show()
	else:
		sleepingsprite.hide()



func _physics_process(_delta):
	if playerinbed and Input.is_action_just_pressed("jump"):
		roomsprite.frame = 0
		player.visible = false
		await get_tree().create_timer(3.0).timeout
		GlobalLevelTracker.level_start()


func _on_bed_mm_body_entered(body: Node2D) -> void:
	if body.name == "AwakePlayer":
		playerinbed = true


func _on_bed_mm_body_exited(body: Node2D) -> void:
	if body.name == "AwakePlayer":
		playerinbed = false
