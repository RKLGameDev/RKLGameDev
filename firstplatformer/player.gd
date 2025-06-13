extends CharacterBody2D

const SPEED = 600.0
const FRICTION = 3000.0
const ACCELERATION = 6000.0
const GRAVITY = 3000.0
const JUMP_VELOCITY = -1000.0  # Negative because Y-axis goes down in Godot

var dir = Vector2(0, 1)

func _physics_process(delta):
	var input_vec = Vector2.ZERO
	
	# Get horizontal input
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec = input_vec.normalized()
	
	# Handle jumping - only if on ground
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# Handle horizontal movement
	if input_vec != Vector2.ZERO:
		velocity.x = move_toward(velocity.x, SPEED * input_vec.x, ACCELERATION * delta)
		dir = input_vec
		# Animation code here
		#animationtree.set("parameters/Idle/blend_position", dir)
		#animationtree.set("parameters/Run/blend_position", dir)
		#animationstate.travel("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		# Animation code here
		#animationstate.travel("Idle")
	
	# Move the character - this handles collisions properly
	move_and_slide()
	
	# Debug output
	print("Input: ", input_vec, " On Floor: ", is_on_floor(), " Velocity: ", velocity)
		
