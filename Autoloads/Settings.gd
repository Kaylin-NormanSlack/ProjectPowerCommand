extends Node

const SETTINGS_PATH: String = "user://settings.json"

var music_volume: int:
	set(value):
		music_volume = value
		_set_music_volume(value)

var sound_volume: int:
	set(value):
		sound_volume = value
		_set_sound_volume(value)

func _init():
	load_settings()

func load_settings():
	var values: Dictionary = {}
	if FileAccess.file_exists(SETTINGS_PATH):
		var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		var json = JSON.parse_string(file.get_as_text())
		if json is Dictionary:
			values = json as Dictionary
	
	self.music_volume = values.get("music_volume", 5)
	self.sound_volume = values.get("sound_volume", 5)

func save_settings():
	var values: Dictionary = {
		"music_volume": self.music_volume,
		"sound_volume": self.sound_volume,
	}
	
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(values))


# Should probably go to some Sound manager

const MUSIC_BUS_INDEX = 1
const SOUND_BUS_INDEX = 2

func _set_audio_bus_volume(bus: int, volume: int):
	AudioServer.set_bus_mute(bus, volume == 0)
	AudioServer.set_bus_volume_db(bus, remap(volume, 0, 10, -45, 0))

func _set_music_volume(value: int):
	_set_audio_bus_volume(MUSIC_BUS_INDEX, value)

func _set_sound_volume(value: int):
	_set_audio_bus_volume(SOUND_BUS_INDEX, value)
