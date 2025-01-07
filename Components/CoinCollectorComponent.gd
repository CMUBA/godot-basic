extends "res://lib/comedot/Scripts/Component.gd"

signal coin_collected(value: int)

func _ready():
	# Make sure we're in the components group
	add_to_group("components")
	
	# Connect to area entered signal
	var area = $Area2D
	if area:
		area.connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D):
	if area.is_in_group("coin"):
		var coin_value = area.get_meta("value", 1)
		emit_signal("coin_collected", coin_value)
		area.queue_free() 