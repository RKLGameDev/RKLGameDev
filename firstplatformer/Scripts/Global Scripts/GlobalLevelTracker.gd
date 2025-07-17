extends Node

var all_games     = ["Platformer"]
var current_game  = "Platformer"

var max_level     = {"Platformer": 2}
var current_level = {"Platformer": 1}
var complete      = false

var level_scene_name = "res://Scenes/Location Scenes/" + current_game + "Lvl" + str(current_level[current_game]) + ".tscn"

func level_start():
	get_tree().change_scene_to_file(level_scene_name)

func next_level():
	if max_level[current_game] != current_level[current_game]:
		current_level[current_game] += 1
	else:
		for i in range(len(all_games)):
			if all_games[i] == current_game:
				if i < len(all_games) - 1:
					current_game = all_games[i+1]
				else:
					complete = true
					break
