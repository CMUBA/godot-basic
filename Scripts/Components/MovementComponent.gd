extends Node

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var ACCELERATION = 1500.0
@export var FRICTION = 1000.0

var direction = Vector2.ZERO
var parent: CharacterBody2D

func _ready():
	parent = get_parent() as CharacterBody2D
	if not parent:
		push_error("MovementComponent must be child of a CharacterBody2D!")
		return

func process_movement():
	if not parent:
		return
		
	# Get input direction
	direction.x = Input.get_axis("move_left", "move_right")
	
	# Handle horizontal movement
	if direction.x != 0:
		parent.velocity.x = move_toward(parent.velocity.x, direction.x * SPEED, ACCELERATION * get_physics_process_delta_time())
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, FRICTION * get_physics_process_delta_time())
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		parent.velocity.y = JUMP_VELOCITY
	
	# Apply gravity
	if not parent.is_on_floor():
		parent.velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * get_physics_process_delta_time()
	
	# Move the character
	parent.move_and_slide()

func is_on_floor() -> bool:
	return parent.is_on_floor() if parent else false

func get_velocity() -> Vector2:
	return parent.velocity if parent else Vector2.ZERO 