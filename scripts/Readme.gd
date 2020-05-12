extends Node2D

func on_return_pressed():
	get_tree().change_scene("res://scenes/Welcome.tscn")

func on_meta_clicked(meta):
	OS.shell_open(meta)
