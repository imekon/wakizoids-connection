extends Node2D

onready var music_button = $PanelContainer/Panel/MusicButton
onready var sfx_button = $PanelContainer/Panel/SFXButton

func on_start_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func on_readme_pressed():
	get_tree().change_scene("res://scenes/Readme.tscn")

func on_music_pressed():
	Global.music_enabled = music_button.pressed

func on_SFX_pressed():
	Global.sounds_enabled = sfx_button.pressed
