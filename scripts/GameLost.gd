extends Node2D

onready var score_label = $PanelContainer/Panel/ScoreLabel

func _ready():
	score_label.text = "Your score was: %d, the high score is %d" % [ Global.player_score, Global.high_score ]

func on_restart_pressed():
	get_tree().change_scene("res://scenes/Welcome.tscn")
