extends Node

signal level_completed(level_number: int, coins_collected: int)
signal game_over

var current_level := 1
var total_coins := 0
var max_levels := 3

func _ready():
	Events.connect("player_died", Callable(self, "_on_player_died"))
	Events.connect("coins_collected", Callable(self, "_on_coins_collected"))
	Events.connect("boss_defeated", Callable(self, "_on_boss_defeated"))
	load_level(current_level)

func load_level(level: int):
	# Clear existing level
	for child in get_tree().get_nodes_in_group("level"):
		child.queue_free()
	
	# Load new level
	var level_scene = load("res://Scenes/Levels/Level%d.tscn" % level)
	if level_scene:
		var level_instance = level_scene.instantiate()
		add_child(level_instance)

func _on_player_died():
	emit_signal("game_over")

func _on_coins_collected(amount: int):
	total_coins += amount

func _on_boss_defeated():
	emit_signal("level_completed", current_level, total_coins)
	if current_level < max_levels:
		current_level += 1
		load_level(current_level)
	else:
		# Game completed
		print("Congratulations! Total coins collected: ", total_coins) 