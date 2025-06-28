extends CharacterBody2D

const GRAVITY 		= 980
const SPEED 		= 500.0
const friction 		= 2800.0
const ACCELERATION 	= 1500.0
const JUMP_VELOCITY = -700.0  # Negative because Y-axis goes down in Godot

var input_dir 		= 0
var current_dir 	= 0

@onready var animatedsprite = $AnimatedSprite2D


func _physics_process(delta):
	
	# Get horizontal input
	input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if input_dir != 0:
		input_dir = input_dir/abs(input_dir)
	
	# Handle jumping - only if on ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# Handle horizontal movement
	if input_dir != 0:
		#Treat Movement Differently when on ground vs in the air
		if is_on_floor():
			current_dir = input_dir
			velocity.x = move_toward(velocity.x, SPEED * input_dir, ACCELERATION * delta)
			# Animation code here
			if input_dir > 0:
				animatedsprite.play("RunRight")
			if input_dir < 0:
				animatedsprite.play("RunLeft")
		else:
			velocity.x = move_toward(velocity.x, SPEED * input_dir, ACCELERATION * delta/5)
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
