extends CharacterBody2D


# ------------------------------------------------------------------------------ #
# ------------------------ A : CONSTANTS AND VARIABLES ------------------------- #
# ------------------------------------------------------------------------------ #

	
#  A.1 -------------- Movement -------------- #
	
#    A.1.1 ------ Movement Constants ------ #
const GRAVITY 		= 980
const run_speed		= 500.0
const friction 		= 2800.0
const acceleration 	= 1500.0
const jump_velocity = -1400.0 
const air_cont_red  = 4
const sprint_speed  = 850.0
const sprint_acc 	= 1200.0
const down_jump_red = 100.0
const up_jump_incr  = -100.0

#    A.1.2 ------ Movement Variables ------ #
var jump = false
var input_dir 		= 0
var current_dir 	= 0
var speed           = run_speed

	
#  A.2 --------------- Falling -------------- #
	
#    A.2.1 ------ Falling Constants ------ #
var fall_damage_vel = 1200

#    A.2.2 ------ Falling Variables ------ #
var last_ok_height  = self.position.y
var fall_damageable = 0




#  A.3 --------------- Loaded --------------- #
	
#    A.3.1 ------- Loaded Variables ------ #
@onready var animatedsprite = $AnimatedSprite2D
@onready var eye_animation  = $Eye/AnimatedSprite2D




#  A.4 --------------- Others --------------- #
	
#    A.4.1 ------- Others Constants ------- #

#    A.4.2 ------- Others Variables ------- #
var health = 4
var alive  = true


# ------------------------------------------------------------------------------ #
# -------------------------------- B : FUNCTIONS ------------------------------- #
# ------------------------------------------------------------------------------ #

func took_damage(current_health):
	if current_health == 0:
		return(100)
	else:
		if current_health == 4:
			eye_animation.play("Eye1")
			#eye_animation.scale = Vector2(eye_animation.scale[0]*1.25, eye_animation.scale[1]*1.25)
		if current_health == 3:
			eye_animation.play("Eye2")
			#eye_animation.scale = Vector2(eye_animation.scale[0]*1.5, eye_animation.scale[1]*1.5)
		if current_health == 2:
			eye_animation.play("Eye3")
			#eye_animation.scale = Vector2(eye_animation.scale[0]*2, eye_animation.scale[1]*2)
		if current_health == 1:
			eye_animation.play("Eye4")
			#eye_animation.scale = Vector2(eye_animation.scale[0]*4, eye_animation.scale[1]*4 )
		return(current_health - 1)


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
		velocity.y += GRAVITY * delta  # Apply gravity
	
	if input_dir != 0: # Handle horizontal movement
		if is_on_floor(): #Treat Movement Differently when on ground vs in the air
			current_dir = input_dir
			if Input.get_action_strength("sprint"):
				velocity.x = move_toward(velocity.x, speed * input_dir, sprint_acc * delta)
			else:
				velocity.x = move_toward(velocity.x, speed * input_dir, acceleration * delta)
		# Animation code here
			if input_dir > 0:
				animatedsprite.play("RunRight")
			if input_dir < 0:
				animatedsprite.play("RunLeft")
		else:
			velocity.x = move_toward(velocity.x, speed * input_dir, acceleration * delta/air_cont_red)
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
			
	move_and_slide() # Move the character - this handles collisions properly
	
	
	
	
#    C.1.2 ---- Movement Features ----- #

#      C.1.2.1 ------ Sprinting ------- #
	if is_on_floor():
		if Input.get_action_strength("sprint"):
			speed = sprint_speed
		else:
			speed = run_speed
			
#      C.1.2.2 ------- Jumping ------- #
	if Input.is_action_just_pressed("PermaJumpOn"):
		jump = true
	if Input.is_action_just_pressed("PermaJumpOff"):
		jump = false
		
	var jumpnow = (Input.is_action_just_pressed("jump") or jump)
	
	if jumpnow and is_on_floor(): # Handle jumping - only if on ground
		if Input.get_action_strength("move_down"):
			velocity.y = jump_velocity + down_jump_red
		elif Input.get_action_strength("move_up"):
			velocity.y = jump_velocity + up_jump_incr
		else:
			velocity.y = jump_velocity
	
	
	
	
#  C.2 --------- Health and Damage ---------- #
	
#    C.2.1 -------- Fall Damage ------- #
	
	if self.velocity.y > fall_damage_vel:
		fall_damageable = 1
		
	if is_on_floor() and fall_damageable == 1:
		health = took_damage(health)
		fall_damageable = 0
		
	if self.velocity.y < fall_damage_vel:
		last_ok_height  = self.position.y
		fall_damageable = 0
			
			
			
	print(health)
			
