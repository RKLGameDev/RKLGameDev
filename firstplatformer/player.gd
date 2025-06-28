extends CharacterBody2D

const GRAVITY 		= 980
const run_speed		= 500.0
const friction 		= 2800.0
const ACCELERATION 	= 1500.0
const JUMP_VELOCITY = -700.0  # Negative because Y-axis goes down in Godot
const air_control_reduction = 4
const sprint_speed  = 850.0
const sprint_ACCELERATION 	= 1200.0
const down_jump_red = 200.0
const up_jump_incr  = -200.0

var jump = false
	
var input_dir 		= 0
var current_dir 	= 0
var speed           = run_speed

@onready var animatedsprite = $AnimatedSprite2D


func _physics_process(delta):
	
	if is_on_floor():
		if Input.get_action_strength("sprint"):
			speed = sprint_speed
		else:
			speed = run_speed
		
	
	
	if Input.is_action_just_pressed("PermaJumpOn"):
		jump = true
	
	if Input.is_action_just_pressed("PermaJumpOff"):
		jump = false
		
	
	var jumpnow = (Input.is_action_just_pressed("jump") or jump)
	
	# Get horizontal input
	input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	

	
	if input_dir != 0:
		input_dir = input_dir/abs(input_dir)
	
	# Handle jumping - only if on ground
	if jumpnow and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if Input.get_action_strength("down"):
			velocity.y = JUMP_VELOCITY + down_jump_red
		if Input.get_action_strength("up"):
			velocity.y = JUMP_VELOCITY + up_jump_incr
	
	
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# Handle horizontal movement
	if input_dir != 0:
		#Treat Movement Differently when on ground vs in the air
		if is_on_floor():
			current_dir = input_dir
			if Input.get_action_strength("sprint"):
				velocity.x = move_toward(velocity.x, speed * input_dir, sprint_ACCELERATION * delta)
			else:
				velocity.x = move_toward(velocity.x, speed * input_dir, ACCELERATION * delta)
			# Animation code here
			if input_dir > 0:
				animatedsprite.play("RunRight")
			if input_dir < 0:
				animatedsprite.play("RunLeft")
		else:
			velocity.x = move_toward(velocity.x, speed * input_dir, ACCELERATION * delta/air_control_reduction)
		# Animation code here
			if input_dir > 0:
				animatedsprite.play("JumpRight")
			if input_dir < 0:
				animatedsprite.play("JumpLeft")
	
	else:
		if is_on_floor():
			current_dir = input_dir
			velocity.x = move_toward(velocity.x, 0, friction * delta)
			# Animation code here
			animatedsprite.play("Idle")
	
	# Move the character - this handles collisions properly
	move_and_slide()
	
	# Debug output
	print("Input: ", input_dir, " On Floor: ", is_on_floor(), " Velocity: ", velocity)
