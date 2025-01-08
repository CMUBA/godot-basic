extends CharacterBody2D

@onready var health_component = $HealthComponent
@onready var movement_component = $MovementComponent
@onready var visual = $ColorRect
@onready var animation_player = $AnimationPlayer

var coins = 0

func _ready():
	# Connect health component signals
	if health_component:
		# Wait a frame to ensure the health component is fully initialized
		await get_tree().process_frame
		health_component.connect("health_changed", Callable(self, "_on_health_changed"))
		health_component.connect("health_depleted", Callable(self, "_on_health_depleted"))
		Events.emit_signal("health_changed", health_component.current_health)
	
	# Create default animation
	if animation_player:
		var library = AnimationLibrary.new()
		var animation = Animation.new()
		
		# Create idle animation
		var track_index = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(track_index, ".:position:y")
		animation.track_insert_key(track_index, 0.0, 0.0)
		animation.track_insert_key(track_index, 0.5, -5.0)
		animation.track_insert_key(track_index, 1.0, 0.0)
		animation.loop_mode = Animation.LOOP_LINEAR
		animation.length = 1.0
		
		library.add_animation("idle", animation)
		animation_player.add_animation_library("", library)

func _physics_process(_delta):
	if movement_component:
		movement_component.process_movement()
		
		# Update visual direction
		if movement_component.direction.x != 0:
			# Flip the ColorRect by adjusting its position
			if movement_component.direction.x < 0:
				visual.position.x = 16
				visual.scale.x = -1
			else:
				visual.position.x = 0
				visual.scale.x = 1
		
		# Simple animation state
		if not animation_player.is_playing():
			animation_player.play("idle")

func collect_coin(value: int = 1):
	coins += value
	Events.emit_signal("coins_changed", coins)

func _on_health_changed(new_health: int):
	Events.emit_signal("health_changed", new_health)

func _on_health_depleted():
	Events.emit_signal("game_over") 
