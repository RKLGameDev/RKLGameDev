extends Node2D 

@onready var spriteframe = $TheSprite
@onready var timer = $Timer

enum potstates {off, on}
var potstate = potstates.off
var coffee_pot_on_frames  = [1, 3, 5, 7, 9]
var coffee_pot_off_frames = [0, 2, 4, 6, 8]

var max_coffee = 4

var amount_of_coffee = 0


@warning_ignore("unused_parameter")
func _process(delta):
	if amount_of_coffee >= max_coffee:
		potstate = potstates.off
	
	if potstate == potstates.on and amount_of_coffee < max_coffee:
		if not timer.is_stopped():
			return
		timer.start(1.5)  # You can also set wait_time in the editor and just call `timer.start()`
	else:
		spriteframe.frame = coffee_pot_off_frames[amount_of_coffee]
	

func drink_cup():
	if amount_of_coffee == 0:
		return(false)
	else:
		amount_of_coffee -= 1
		return(true)
	
func _on_timer_timeout() -> void:
	if potstate == potstates.on:
		amount_of_coffee = amount_of_coffee + 1
		spriteframe.frame = coffee_pot_on_frames[amount_of_coffee]

@warning_ignore("unused_parameter")
func _on_on_off_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if potstate == potstates.on:
			potstate = potstates.off
			timer.stop()
		if potstate == potstates.off:
			potstate = potstates.on

@warning_ignore("unused_parameter")
func _on_pot_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if amount_of_coffee > 0:
			amount_of_coffee = amount_of_coffee - 1
