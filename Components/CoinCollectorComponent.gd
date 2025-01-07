extends Area2D

signal coin_collected(value: int)

# Component properties
@export var enabled := true
var entity: Node

func _ready():
	# Component initialization
	add_to_group("components")
	entity = get_parent()
	
	# Setup collision detection
	collision_layer = 0  # We don't collide with anything
	collision_mask = 4   # We only detect coins (layer 3)
	
	# Connect to area entered signal
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D):
	if not enabled:
		return
		
	if area.is_in_group("coin"):
		var coin_value = area.get_meta("value", 1)
		emit_signal("coin_collected", coin_value)
		area.queue_free()

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false 