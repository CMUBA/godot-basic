extends Node2D

@onready var enemies = get_node_or_null("Enemies")
@onready var boss = get_node_or_null("Boss")
@onready var coins = get_node_or_null("Coins")

func _ready():
	if enemies:
		# Connect to enemy death signals
		for enemy in enemies.get_children():
			if enemy.has_node("HealthComponent"):
				enemy.get_node("HealthComponent").connect("health_depleted", 
					Callable(self, "_on_enemy_died").bind(enemy))
	
	if boss and boss.get_child_count() > 0:
		# Connect to boss death signal
		var boss_entity = boss.get_child(0)
		if boss_entity.has_node("HealthComponent"):
			boss_entity.get_node("HealthComponent").connect("health_depleted",
				Callable(self, "_on_boss_died"))

func _on_enemy_died(enemy: Node2D):
	if not coins:
		return
		
	# Spawn coins when enemy dies
	var coin_scene = load("res://Entities/Collectibles/Coin.tscn")
	var coin = coin_scene.instantiate()
	coin.position = enemy.position
	coins.add_child(coin)
	enemy.queue_free()

func _on_boss_died():
	# Emit signal when boss is defeated
	Events.emit_signal("boss_defeated") 