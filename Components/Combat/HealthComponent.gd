extends "res://Scripts/Core/Component.gd"

signal health_changed(new_health: float, old_health: float)
signal health_depleted

@export var max_health := 100.0
@export var current_health := 100.0
@export var invincible := false

func take_damage(amount: float) -> void:
	if invincible or amount <= 0:
		return
	
	var old_health = current_health
	current_health = clamp(current_health - amount, 0, max_health)
	
	emit_signal("health_changed", current_health, old_health)
	
	if current_health <= 0:
		emit_signal("health_depleted")

func heal(amount: float) -> void:
	if amount <= 0:
		return
	
	var old_health = current_health
	current_health = clamp(current_health + amount, 0, max_health)
	
	emit_signal("health_changed", current_health, old_health)

func is_alive() -> bool:
	return current_health > 0 