extends CharacterBody2D

@onready var health_component = $HealthComponent
@onready var coin_collector = $CoinCollector
@onready var platformer_movement = $PlatformerMovement
@onready var visual = $ColorRect

func _ready():
	# Connect signals
	health_component.connect("health_depleted", Callable(self, "_on_death"))
	health_component.connect("health_changed", Callable(self, "_on_health_changed"))
	coin_collector.connect("coin_collected", Callable(self, "_on_coin_collected"))
	
	# Set initial values
	health_component.current_health = health_component.max_health

func _on_death():
	Events.emit_signal("player_died")
	# Play death animation
	# Disable controls
	platformer_movement.disable()

func _on_health_changed(new_health: float, old_health: float):
	Events.emit_signal("player_health_changed", new_health, health_component.max_health)
	if new_health < old_health:
		# Play hit animation/effect
		pass

func _on_coin_collected(value: int):
	Events.emit_signal("coins_collected", value)
	# Play coin collection effect
	pass

func take_damage(amount: float):
	health_component.take_damage(amount)

func heal(amount: float):
	health_component.heal(amount)

func _physics_process(_delta: float) -> void:
	# Update visual direction based on movement
	if velocity.x != 0:
		visual.scale.x = -1 if velocity.x < 0 else 1 