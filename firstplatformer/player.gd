extends CharacterBody2D

const GRAVITY = 980
const SPEED = 1000.0
const friction = 1000.0
const ACCELERATION = 3000.0
const JUMP_VELOCITY = -800.0  # Negative because Y-axis goes down in Godot

var input_dir = 0

@onready var animationplayer = $AnimationPlayer
@onready var animationtree = $AnimationTree 
@onready var animationstate = animationtree.get("parameters/playback")



func _physics_process(delta):
	
	
	# Get horizontal input
	input_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if input_dir != 0:
		input_dir = input_dir/abs(input_dir)
	
	# Handle jumping - only if on ground
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	
	
	# Handle horizontal movement
	if input_dir != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_dir, ACCELERATION * delta)
		# Animation code here
		if input_dir > 0:
			animationstate.travel("RunRight")
		if input_dir < 0:
			animationstate.travel("RunLeft")
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		# Animation code here
		animationstate.travel("Idle")
	
	# Move the character - this handles collisions properly
	move_and_slide()
	
	# Debug output
	print("Input: ", input_dir, " On Floor: ", is_on_floor(), " Velocity: ", velocity)
		
		
