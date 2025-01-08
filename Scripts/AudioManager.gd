extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	sfx_player = AudioStreamPlayer.new()
	
	add_child(music_player)
	add_child(sfx_player)
	
	# Load and play background music
	var music = load("res://Assets/Audio/Campus Clash.mp3")
	if music:
		music_player.stream = music
		music_player.volume_db = -10
		music_player.play()

func play_sfx(sfx_path: String):
	var sfx = load(sfx_path)
	if sfx:
		sfx_player.stream = sfx
		sfx_player.play() 