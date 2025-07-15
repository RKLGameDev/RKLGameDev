extends CharacterBody2D


# ------------------------------------------------------------------------------ #
# ------------------------ A : CONSTANTS AND VARIABLES ------------------------- #
# ------------------------------------------------------------------------------ #

	
#  A.1 -------------- Movement -------------- #
	
#    A.1.1 ------ Movement Constants ------ #
			
#      A.1.1.1 ------ On Ground ------ #
const base_run_speed		= 500.0
const base_friction 		= 2800.0
const base_acceleration 	= 2200.0
const base_sprint_speed     = 850.0
const base_sprint_acc 	    = 2000.0

#      A.1.1.2 -------- In Air ------- #
const gravity 		        = 980
const base_jump_velocity    = -700.0 
const base_air_cont_red     = 4  # Determines how much control the character has in the air
const base_down_jump_red    = 100.0
const base_up_jump_incr     = -100.0



#    A.1.2 ------ Movement Variables ------ #

#      A.1.1.1 ------ On Ground ------ #

var run_speed		= base_run_speed	
var friction 		= base_friction 	
var acceleration 	= base_acceleration
var sprint_speed    = base_sprint_speed
var sprint_acc 	    = base_sprint_acc 	
var input_dir 		= 0
var current_dir 	= 0
var speed           = 0

#      A.1.1.2 -------- In Air ------- #
var jump_velocity   = base_jump_velocity
var air_cont_red    = base_air_cont_red 
var down_jump_red   = base_down_jump_red
var up_jump_incr    = base_up_jump_incr 

var doublejump      = false





#  A.2 --------------- Falling -------------- #
	
#    A.2.1 ------ Falling Constants ------ #
var fall_damage_vel = 1200

#    A.2.2 ------ Falling Variables ------ #
var last_ok_height  = self.position.y
var fall_damageable = 0




#  A.3 --------------- Loaded --------------- #
	
#    A.3.1 ------- Loaded Variables ------ #
@onready var animatedsprite = $AnimatedSprite2D
@onready var doublejumpanim = $DoubleJumpEffect
@onready var eye_animation  = $Eye/AnimatedSprite2D
@onready var camera         = $Camera2D




#  A.4 --------------- Others --------------- #
	
#    A.4.1 ------- Others Constants ------- #

#    A.4.2 ------- Others Variables ------- #
var health        = 4
var alive         = true
var scale_tracker = 0.0
var scale_factor  = 4.0/3.0
var can_scale     = false
var can_dblejump  = false
var damaged       = false
var upgrade_damage= false







# ------------------------------------------------------------------------------ #
# -------------------------------- B : FUNCTIONS ------------------------------- #
# ------------------------------------------------------------------------------ #

func took_damage(current_health):
	if current_health == 0:
		return(100)
	else:
		if current_health == 4:
			eye_animation.play("Eye1")
		if current_health == 3:
			eye_animation.play("Eye2")
		if current_health == 2:
			eye_animation.play("Eye3")
		if current_health == 1:
			eye_animation.play("Eye4")
		return(current_health - 1)


func recover(current_health):
	if current_health == 4:
		return(4)
	else:
		if current_health == 3:
			eye_animation.play_backwards("Eye1")
		if current_health == 2:
			eye_animation.play_backwards("Eye2")
		if current_health == 1:
			eye_animation.play_backwards("Eye3")
		if current_health == 0:
			eye_animation.play_backwards("Eye4")
		return(current_health + 1)

func jumping():
	if Input.get_action_strength("move_down"):
		velocity.y = jump_velocity + down_jump_red
	elif Input.get_action_strength("move_up"):
		velocity.y = jump_velocity + up_jump_incr
	else:
		velocity.y = jump_velocity




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
	var jumpnow = Input.is_action_just_pressed("jump")
	
	if jumpnow and is_on_floor(): # Handle jumping - only if on ground)
		jumping()
		
	
	
#  C.2 --------- Health and Damage ---------- #
	
#    C.2.0 ---- Damage Application ---- #
	if damaged:
		health = took_damage(health)
		damaged = false
	
#    C.2.1 -------- Fall Damage ------- #
	if self.velocity.y > fall_damage_vel:
		fall_damageable = 1
		
	if is_on_floor() and fall_damageable == 1:
		damaged = true
		fall_damageable = 0
		
	if self.velocity.y < fall_damage_vel:
		last_ok_height  = self.position.y
		fall_damageable = 0
	
#    C.2.3 ------ Upgrade Damage ------ #
	if upgrade_damage:
		damaged = true
		upgrade_damage = false
		
	
	
	
#  C.3 ---------- Other Mechanics ----------- #
	
#    C.3.1 -------- Double Jump ------- #

	if can_dblejump:
		if jumpnow and can_dblejump and doublejump: 
			if not is_on_floor():
				doublejumpanim.play("DoubleJump")
			doublejump = false
			jumping()
		
		if is_on_floor():
			doublejump = true
			
			
	
#    C.3.2 ------ Shink and Grow ------ #

	if can_scale:
		if Input.is_action_just_pressed("Shrink") and scale_tracker > -4:
			scale = (1.0/scale_factor) * scale
			camera.zoom = scale_factor * camera.zoom
			scale_tracker -= 1
			if scale_tracker < 4:
				fall_damage_vel *= 1.5
			else:
				fall_damage_vel = 999999999
			
		if Input.is_action_just_pressed("Grow") and scale_tracker < 4:
			scale = scale_factor * scale
			camera.zoom = (1.0/scale_factor) * camera.zoom
			scale_tracker += 1

		sprint_speed    = (scale_factor ** (scale_tracker/2.0)) * base_sprint_speed 
		run_speed		= (scale_factor ** (scale_tracker/2.0)) * base_run_speed
		air_cont_red    = max(2, base_air_cont_red + (0.5 * scale_tracker))

		acceleration 	= (scale_factor ** scale_tracker)     * base_acceleration 
		sprint_acc 	    = (scale_factor ** scale_tracker)     * base_sprint_acc 	 
		friction 		= (scale_factor ** scale_tracker)     * base_friction 	

		jump_velocity   = (scale_factor ** (scale_tracker/2.0)) * base_jump_velocity
		down_jump_red   = (scale_factor ** (scale_tracker/2.0)) * base_down_jump_red
		up_jump_incr    = (scale_factor ** (scale_tracker/2.0)) * base_up_jump_incr 

	
