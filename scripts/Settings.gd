extends Node2D

onready var music_button = $PanelContainer/Panel/MusicButton
onready var sfx_button = $PanelContainer/Panel/SFXButton

onready var music_slider = $PanelContainer/Panel/MusicSlider
onready var sfx_slider = $PanelContainer/Panel/SFXSlider

onready var music = $Music

func _ready():
	music_button.pressed = Global.music_enabled
	sfx_button.pressed = Global.sounds_enabled
	
	music_slider.value = Global.music_gain * 100
	sfx_slider.value = Global.sound_gain * 100
	
	music.volume_db = Global.convert_gain_to_db(Global.music_gain)
	music.play()
	
func on_apply_pressed():
	get_tree().change_scene("res://scenes/Welcome.tscn")

func on_music_button_pressed():
	Global.music_enabled = music_button.pressed
	
	if Global.music_enabled:
		music.play()
	else:
		music.stop()

func on_SFX_button_pressed():
	Global.sounds_enabled = sfx_button.pressed

func on_music_slider_value_changed(value):
	Global.music_gain = value / 100
	music.volume_db = Global.convert_gain_to_db(Global.music_gain)

func on_SFX_slider_value_changed(value):
	Global.sound_gain = sfx_slider.value / 100
