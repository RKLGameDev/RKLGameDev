extends Node

enum times_of_day {day, sunset, night, latenight}
enum light_states {on, off}
enum fan_states {on, off}

var time_of_day
var light_state
var fan_state
var startup = true
var global_property_change = false
