extends CharacterBody2D


# ------------------------------------------------------------------------------ #
# ------------------------ A : CONSTANTS AND VARIABLES ------------------------- #
# ------------------------------------------------------------------------------ #

	
#  A.1 -------------- Movement -------------- #
	
#    A.1.1 ------ Movement Constants ------ #
			
#      A.1.1.1 ------ On Ground ------ #
const base_run_speed		= 40.0
const base_friction 		= 200.0
const base_acceleration 	= 100.0

#      A.1.1.2 -------- In Air ------- #
const gravity 		        = 980



#    A.1.2 ------ Movement Variables ------ #

#      A.1.1.1 ------ On Ground ------ #

var run_speed		= base_run_speed	
var friction 		= base_friction 	
var acceleration 	= base_acceleration

#      A.1.1.2 -------- In Air ------- #

var input_dir 		= 0
var current_dir 	= 0
var speed = run_speed




#  A.3 --------------- Loaded --------------- #
	
#    A.3.1 ------- Loaded Variables ------ #
@onready var animatedsprite = $AwakeSprite





# ------------------------------------------------------------------------------ #
# ----------------------------- C : PHYSICS PROCESS ---------------------------- #
# ------------------------------------------------------------------------------ #

func _physics_process(delta):
	
#  C.1 -------------- Movement -------------- #
	
#    C.1.1 ------ Basic Movement ------ #

	input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if input_dir != 0:
		input_dir = input_dir/abs(input_dir)
		
	if not is_on_floor():
		#velocity.y += gravity * delta  # Apply gravity
		velocity.y = move_toward(velocity.y, 9000000000000000000, gravity * delta)
	
	if input_dir != 0: # Handle horizontal movement
		current_dir = input_dir
		velocity.x = move_toward(velocity.x, speed * input_dir, acceleration * delta)

	# Animation code here
		if input_dir > 0:
			animatedsprite.play("WalkRight")
		if input_dir < 0:
			animatedsprite.play("WalkLeft")
	else:
		current_dir = input_dir
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		# Animation code here
		animatedsprite.play("Idle")
			
	move_and_slide() # Move the character - this handles collisions properly
