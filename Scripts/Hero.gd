extends "res://lib/comedot/Entities/Characters/PlayerEntity.gd"

@onready var health_component = $HealthComponent
@onready var damage_component = $DamageComponent
@onready var coin_collector = $CoinCollectorComponent

func _ready():
	super._ready()
	health_component.connect("health_depleted", Callable(self, "_on_death"))
	coin_collector.connect("coin_collected", Callable(self, "_on_coin_collected"))

func _on_death():
	Events.emit_signal("player_died")

func _on_coin_collected(value: int):
	Events.emit_signal("coins_collected", value) 