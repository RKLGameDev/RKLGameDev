extends CharacterBody2D


const speed = 600
var vel = Vector2.ZERO
const friction = 3000
var dir = Vector2(0,1)
var acc = 6000
const GRAVITY = 3000
const jumpspeed = 1500


var dir = Vector2(0, 1)

func _physics_process(delta):
	var input_vec = Vector2.ZERO
	
	velocity.y += delta * GRAVITY

	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  speed
	else:
		velocity.x = 0

	
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if jump:
		velocity.y = -jumpspeed
		
	# "move_and_slide" already takes delta time into account.
	move_and_slide()
																			  
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index).get_collider()
		if not jump and collision.name.begins_with("Ground"):
			print("I'm Grounded")
			velocity.y = 0
	if get_slide_collision_count() == 0:
		print("I'm Freeee")
	