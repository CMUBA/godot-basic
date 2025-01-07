extends Node

# Player events
signal player_died
signal player_health_changed(new_health: float, max_health: float)
signal coins_collected(amount: int)

# Level events
signal level_started(level_number: int)
signal level_completed(level_number: int)
signal boss_defeated

# Game events
signal game_started
signal game_over
signal game_paused
signal game_resumed

# UI events
signal show_message(text: String)
signal hide_message 