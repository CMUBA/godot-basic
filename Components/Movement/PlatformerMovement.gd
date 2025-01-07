extends "res://Scripts/Core/GameComponent.gd"

@export_group("Movement")
@export var move_speed := 300.0
@export var acceleration := 2000.0
@export var friction := 1000.0
@export var air_friction := 200.0

@export_group("Jump")
@export var jump_force := -400.0
@export var gravity := 980.0
@export var max_fall_speed := 1000.0
@export var jump_cut_force := 0.4
@export var coyote_time := 0.1
@export var jump_buffer_time := 0.1

var velocity := Vector2.ZERO
var is_jumping := false
var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var last_floor_position := Vector2.ZERO

@onready var character_body: CharacterBody2D = entity as CharacterBody2D

func _setup() -> void:
	if not character_body:
		push_error("PlatformerMovement must be child of a CharacterBody2D")
		disable()

func _physics_update(delta: float) -> void:
	if not character_body:
		return
		
	# Update timers
	coyote_timer = max(0, coyote_timer - delta)
	jump_buffer_timer = max(0, jump_buffer_timer - delta)
		
	# Apply gravity
	velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	
	# Get input
	var input_dir := Input.get_axis("move_left", "move_right")
	
	# Handle horizontal movement
	if input_dir != 0:
		velocity.x = move_toward(velocity.x, input_dir * move_speed, acceleration * delta)
	else:
		var friction_force = friction if character_body.is_on_floor() else air_friction
		velocity.x = move_toward(velocity.x, 0, friction_force * delta)
	
	# Handle jumping
	if character_body.is_on_floor():
		coyote_timer = coyote_time
		last_floor_position = character_body.global_position
		is_jumping = false
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_force
		is_jumping = true
		jump_buffer_timer = 0
		coyote_timer = 0
	
	# Cut jump height if button released
	if Input.is_action_just_released("jump") and velocity.y < 0 and is_jumping:
		velocity.y *= jump_cut_force
	
	# Apply movement
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity 