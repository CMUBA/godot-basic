extends Control

@onready var create_dialog = $CreateDialog
@onready var create_button = $CenterContainer/VBoxContainer/MenuButtons/CreateButton
@onready var play_button = $CenterContainer/VBoxContainer/MenuButtons/PlayButton
@onready var load_button = $CenterContainer/VBoxContainer/MenuButtons/LoadButton
@onready var quit_button = $CenterContainer/VBoxContainer/MenuButtons/QuitButton
@onready var name_edit = $CreateDialog/CenterContainer/VBoxContainer/NameEdit
@onready var create_confirm_button = $CreateDialog/CenterContainer/VBoxContainer/CreateConfirmButton

func _ready():
	# Connect button signals
	if create_button and play_button and load_button and quit_button and create_confirm_button:
		create_button.connect("pressed", Callable(self, "_on_create_pressed"))
		play_button.connect("pressed", Callable(self, "_on_play_pressed"))
		load_button.connect("pressed", Callable(self, "_on_load_pressed"))
		quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))
		create_confirm_button.connect("pressed", Callable(self, "_on_create_confirm"))
	else:
		push_error("Some menu buttons are missing!")
		return
	
	# Add escape key handling
	Events.connect("game_paused", Callable(self, "_on_game_paused"))
	
	# Check if save exists
	if not Settings.has_setting("player_name"):
		play_button.disabled = true
		load_button.disabled = true

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Events.emit_signal("game_paused")

func _on_create_pressed():
	if create_dialog:
		create_dialog.show()

func _on_create_confirm():
	if not name_edit:
		return
		
	var player_name = name_edit.text.strip_edges()
	if player_name.length() > 0:
		Settings.player_name = player_name
		Settings.save_settings()
		play_button.disabled = false
		load_button.disabled = false
		create_dialog.hide()
		_on_play_pressed()

func _on_play_pressed():
	Events.emit_signal("game_started")
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")

func _on_load_pressed():
	if Settings.has_setting("current_level"):
		var level = Settings.get_setting("current_level", 1)
		get_tree().change_scene_to_file("res://Scenes/Levels/Level%d.tscn" % level)

func _on_quit_pressed():
	get_tree().quit()

func _on_game_paused():
	if not visible:
		show()
	else:
		hide() 