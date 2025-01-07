extends Control

@onready var create_dialog = $CreateDialog
@onready var create_button = $MenuButtons/CreateButton
@onready var play_button = $MenuButtons/PlayButton
@onready var load_button = $MenuButtons/LoadButton
@onready var quit_button = $MenuButtons/QuitButton
@onready var name_edit = $CreateDialog/VBoxContainer/NameEdit
@onready var create_confirm_button = $CreateDialog/VBoxContainer/CreateConfirmButton

func _ready():
	# Connect button signals
	create_button.connect("pressed", Callable(self, "_on_create_pressed"))
	play_button.connect("pressed", Callable(self, "_on_play_pressed"))
	load_button.connect("pressed", Callable(self, "_on_load_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))
	create_confirm_button.connect("pressed", Callable(self, "_on_create_confirm"))
	
	# Check if save exists
	if not Settings.has_setting("player_name"):
		play_button.disabled = true
		load_button.disabled = true

func _on_create_pressed():
	create_dialog.show()

func _on_create_confirm():
	var player_name = name_edit.text.strip_edges()
	if player_name.length() > 0:
		Settings.player_name = player_name
		Settings.save_settings()
		play_button.disabled = false
		load_button.disabled = false
		create_dialog.hide()
		_on_play_pressed()

func _on_play_pressed():
	# Start new game
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")

func _on_load_pressed():
	# Load saved game
	if Settings.has_setting("current_level"):
		var level = Settings.get_setting("current_level", 1)
		get_tree().change_scene_to_file("res://Scenes/Levels/Level%d.tscn" % level)

func _on_quit_pressed():
	get_tree().quit() 