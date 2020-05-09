extends Node2D

onready var score_label = $PlayerShip/HUD/ScoreLabel

func _ready():
	build_rocks()

func _process(delta):
	var players = get_tree().get_nodes_in_group("player")
	var player = players.front()
	score_label.text = "Score: " + str(player.score)

func build_rocks():
	pass
