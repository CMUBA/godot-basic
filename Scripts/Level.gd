extends Node2D

@onready var enemies = $Enemies
@onready var boss = $Boss

func _ready():
	# Connect to enemy death signals
	for enemy in enemies.get_children():
		if enemy.has_node("HealthComponent"):
			enemy.get_node("HealthComponent").connect("health_depleted", 
				Callable(self, "_on_enemy_died").bind(enemy))
	
	# Connect to boss death signal
	if boss.get_child_count() > 0:
		var boss_entity = boss.get_child(0)
		if boss_entity.has_node("HealthComponent"):
			boss_entity.get_node("HealthComponent").connect("health_depleted",
				Callable(self, "_on_boss_died"))

func _on_enemy_died(enemy: Node2D):
	# Spawn coins when enemy dies
	var coin_scene = load("res://Scenes/Coin.tscn")
	var coin = coin_scene.instantiate()
	coin.position = enemy.position
	$Coins.add_child(coin)
	enemy.queue_free()

func _on_boss_died():
	# Emit signal when boss is defeated
	Events.emit_signal("boss_defeated") 