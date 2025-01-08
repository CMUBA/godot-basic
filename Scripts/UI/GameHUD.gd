extends Control

@onready var health_label = $MarginContainer/HBoxContainer/HealthContainer/HealthValue
@onready var coins_label = $MarginContainer/HBoxContainer/CoinsContainer/CoinsValue

func _ready():
	Events.connect("health_changed", Callable(self, "_on_health_changed"))
	Events.connect("coins_changed", Callable(self, "_on_coins_changed"))
	
	# Initialize values
	health_label.text = str(100)
	coins_label.text = str(0)

func _on_health_changed(new_health: int):
	health_label.text = str(new_health)

func _on_coins_changed(new_coins: int):
	coins_label.text = str(new_coins) 