extends Node

const SAVE_PATH = "user://settings.save"

var _settings = {}

func _ready():
	load_settings()

func has_setting(key: String) -> bool:
	return _settings.has(key)

func get_setting(key: String, default_value = null):
	return _settings.get(key, default_value)

func set_setting(key: String, value) -> void:
	_settings[key] = value
	save_settings()

func _set(property: StringName, value) -> bool:
	_settings[property] = value
	save_settings()
	return true

func _get(property: StringName):
	if _settings.has(property):
		return _settings[property]
	return null

func save_settings() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(_settings)
		file = null

func load_settings() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			_settings = file.get_var()
			file = null 