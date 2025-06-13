extends CharacterBody2D

# Movement constants
@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var GRAVITY: float = 980.0
@export var COYOTE_TIME: float = 0.1
@export var JUMP_BUFFER_TIME: float = 0.1

# Internal variables
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var was_on_floor: bool = false

func _ready():
	# Ensure the character has proper collision setup
	if not has_method("move_and_slide"):
		push_error("CharacterBody2D is required for proper collision resolution")

func _physics_process(delta):
	handle_gravity(delta)
	handle_input()
	handle_coyote_time(delta)
	handle_jump_buffering(delta)
	
	# Move and slide with collision resolution
	var collision_occurred = move_and_slide()
	
	# Additional ground snapping for slopes
	if is_on_floor() and velocity.y >= 0:
		snap_to_ground()

func handle_gravity(delta):
	# Add gravity when not on floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		# Reset vertical velocity when landing
		if velocity.y > 0:
			velocity.y = 0

func handle_input():
	# Handle horizontal movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.1)
	
	# Handle jump input
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME

func handle_coyote_time(delta):
	# Track if we were on floor last frame
	if was_on_floor and not is_on_floor():
		coyote_timer = COYOTE_TIME
	elif is_on_floor():
		coyote_timer = 0.0
	else:
		coyote_timer -= delta
	
	was_on_floor = is_on_floor()

func handle_jump_buffering(delta):
	# Process jump if conditions are met
	if jump_buffer_timer > 0:
		if is_on_floor() or coyote_timer > 0:
			perform_jump()
			jump_buffer_timer = 0.0
			coyote_timer = 0.0
		else:
			jump_buffer_timer -= delta
	else:
		jump_buffer_timer = 0.0

func perform_jump():
	velocity.y = JUMP_VELOCITY

func snap_to_ground():
	# Additional ground snapping for better collision on slopes
	if velocity.y >= 0:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + Vector2(0, 10),
			collision_mask
		)
		var result = space_state.intersect_ray(query)
		
		if result:
			var snap_distance = result.position.y - global_position.y
			if snap_distance > 0 and snap_distance <= 8:
				global_position.y = result.position.y

# Optional: Add wall collision response
func handle_wall_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		
		# If hitting a wall (normal is mostly horizontal)
		if abs(normal.x) > 0.7:
			# Stop horizontal movement
			velocity.x = 0

# Debug function to visualize collision info
func _draw():
	if Engine.is_editor_hint():
		return
	
	# Draw collision normal vectors for debugging
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var pos = to_local(collision.get_position())
		var normal = collision.get_normal() * 50
		draw_line(pos, pos + normal, Color.RED, 2)

# Additional helper functions
func is_falling() -> bool:
	return velocity.y > 0 and not is_on_floor()

func is_jumping() -> bool:
	return velocity.y < 0

func get_movement_direction() -> int:
	if velocity.x > 0:
		return 1
	elif velocity.x < 0:
		return -1
	else:
		return 0
