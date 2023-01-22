extends Control

@export var MainMenu: String

@onready var music_volume_slider := %MusicVolumeSlider
@onready var sound_volume_slider := %SoundVolumeSlider

func _ready():
	music_volume_slider.value = Settings.music_volume
	sound_volume_slider.value = Settings.sound_volume


func _on_music_volume_changed(value):
	Settings.music_volume = value
	Settings.save_settings()


func _on_sound_volume_changed(value):
	Settings.sound_volume = value
	Settings.save_settings()


func _on_back_button_pressed():
	Game.emit_signal("ChangeScene", MainMenu)
