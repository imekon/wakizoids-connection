extends Node2D

const TWEEN_DURATION_UP = 1.3
const TWEEN_DURATION_DOWN = 1.7

onready var symbol1 = $PanelContainer/Panel/symbol1
onready var symbol2 = $PanelContainer/Panel/symbol2
onready var symbol3 = $PanelContainer/Panel/symbol3
onready var symbol4 = $PanelContainer/Panel/symbol4
onready var symbol5 = $PanelContainer/Panel/godot_game_jam

onready var tween_up = $PanelContainer/Panel/TweenUp
onready var tween_down = $PanelContainer/Panel/TweenDown

var last_index = -1
var last_symbol = null

func _ready():
	randomize()
	process_glow_loop()

func process_glow_loop():
	while true:
		process_glow()
		yield(tween_up, "tween_completed")
		
func process_glow():
	last_index += 1
	
	if last_index > 4:
		last_index = 0

	match last_index:
		0:
			process_up(symbol1)
		1:
			process_up(symbol2)
		2:
			process_up(symbol3)
		3:
			process_up(symbol4)
		4:
			process_up(symbol5)
			
func process_down():
	if last_symbol == null:
		return
	
	tween_down.interpolate_property(last_symbol, "modulate", Color(1.5, 1, 1), Color(1, 1, 1), TWEEN_DURATION_DOWN, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_down.start()
	
	last_symbol = null
	
func process_up(symbol):
	if last_symbol != symbol:
		process_down()
	
	tween_up.interpolate_property(symbol, "modulate", Color(1, 1, 1), Color(1.5, 1, 1), TWEEN_DURATION_UP, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_up.start()
	
	last_symbol = symbol	
	


func on_start_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func on_readme_pressed():
	get_tree().change_scene("res://scenes/Readme.tscn")

func on_settings_pressed():
	get_tree().change_scene("res://scenes/Settings.tscn")
