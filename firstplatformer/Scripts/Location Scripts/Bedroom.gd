extends Node2D

#@onready var player_scene = preload("res://Scenes/AwakePlayer.tscn") 

@onready var roomsprite     = $TheRoom/RoomSprite
@onready var outsidesprite  = $TheRoom/OutsideSprite
@onready var lightingsprite = $TheRoom/LightingSprite
@onready var trdcharsprite  = $TheRoom/TiredChar
@onready var sleepingsprite = $TheRoom/SleepingChar
@onready var player         = $TheRoom/CommonBedroomAssets/AwakePlayer
@onready var ceilingfan     = $TheRoom/CommonBedroomAssets/FanLightSwitch/CeilingFan/CeilingFan

@onready var times_of_day = MainRoomGlobal.times_of_day
@onready var light_states = MainRoomGlobal.light_states

var playerinbed = false

func state_update():
	if MainRoomGlobal.time_of_day == times_of_day.sunset:
		outsidesprite.frame = 0
		if MainRoomGlobal.light_state == MainRoomGlobal.light_states.on:
			lightingsprite.frame = 0
		if MainRoomGlobal.light_state == MainRoomGlobal.light_states.off:
			lightingsprite.frame = 1
			
	if MainRoomGlobal.time_of_day == times_of_day.day:
		outsidesprite.frame = 1
		if MainRoomGlobal.light_state == MainRoomGlobal.light_states.on:
			lightingsprite.frame = 2
		if MainRoomGlobal.light_state == MainRoomGlobal.light_states.off:
			lightingsprite.frame = 3
			
	if MainRoomGlobal.time_of_day == times_of_day.night or MainRoomGlobal.time_of_day == times_of_day.latenight:
		outsidesprite.frame = 2
		if MainRoomGlobal.light_state == MainRoomGlobal.light_states.on:
			lightingsprite.frame = 4
		if MainRoomGlobal.light_state == MainRoomGlobal.light_states.off:
			lightingsprite.frame = 5
			
	MainRoomGlobal.global_property_change = false
			

func _ready():
	
	if MainRoomGlobal.startup == true:
		MainRoomGlobal.time_of_day = MainRoomGlobal.times_of_day.sunset
		MainRoomGlobal.light_state = MainRoomGlobal.light_states.on
		MainRoomGlobal.fan_state   = MainRoomGlobal.fan_states.on
		MainRoomGlobal.startup = false

	state_update()
	
	if MainRoomGlobal.time_of_day == times_of_day.latenight:
		state_update()
		player.hide()
		sleepingsprite.hide()
		trdcharsprite.show()
		await get_tree().create_timer(2.0).timeout
		trdcharsprite.hide()
		player.show()
	else:
		state_update()
		trdcharsprite.hide()
	
	if MainRoomGlobal.time_of_day == times_of_day.day:
		state_update()
		player.hide()
		sleepingsprite.show()
		trdcharsprite.hide()
		await get_tree().create_timer(2.0).timeout
		sleepingsprite.hide()
		player.show()
	else:
		state_update()
		sleepingsprite.hide()



func _physics_process(_delta):
	if MainRoomGlobal.global_property_change:
		state_update()
	if playerinbed and Input.is_action_just_pressed("jump"):
		player.visible = false
		sleepingsprite.show()
		await get_tree().create_timer(3.0).timeout
		GlobalLevelTracker.level_start()
		
		




func _on_bed_mm_body_entered(body: Node2D) -> void:
	if body.name == "AwakePlayer":
		playerinbed = true


func _on_bed_mm_body_exited(body: Node2D) -> void:
	if body.name == "AwakePlayer":
		playerinbed = false
