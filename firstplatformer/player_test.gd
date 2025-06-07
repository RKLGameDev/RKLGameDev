extends CharacterBody2D

const speed = 300
var vel = Vector2.ZERO
const friction = 300
var dir = Vector2(0,1)
var acc = 600
const GRAVITY = 20000
const jumpspeed = 1000


func _physics_process(delta):
	var input_vec = Vector2.ZERO
	var jump=0
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	jump = Input.get_action_strength("ui_select")
	input_vec = input_vec.normalized()
	print(jump)
	if input_vec != Vector2.ZERO:# and health > 0:
		vel = vel.move_toward(speed*input_vec, delta*acc)
		dir = input_vec*(1/max(abs(input_vec.x),abs(input_vec.y)))
		#animationtree.set("parameters/Idle/blend_position",dir)
		#animationtree.set("parameters/Run/blend_position",dir)
		#animationstate.travel("Run")
	else:
		vel = vel.move_toward(Vector2.ZERO, friction*delta)
		#animationstate.travel("Idle")
	velocity = vel	
	velocity.y += GRAVITY * delta
	if jump>0:
		velocity.y = -jumpspeed
# warning-ignore:return_value_discarded
	move_and_slide()
