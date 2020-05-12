extends Node

const EDGE_UNIVERSE = 20000
const EDGE_UNIVERSE2 = 40000

onready var symbol1 = preload("res://scenes/Symbol1.tscn")
onready var symbol2 = preload("res://scenes/Symbol2.tscn")
onready var symbol3 = preload("res://scenes/Symbol3.tscn")
onready var symbol4 = preload("res://scenes/Symbol4.tscn")

onready var explosion = preload("res://scenes/Explosion.tscn")

var player
var main

var symbol_scenes = []
var symbols = []
var collected_symbols = [ false, false, false, false ]
var current_symbol = 0

func _ready():
	symbol_scenes.append(symbol1)
	symbol_scenes.append(symbol2)
	symbol_scenes.append(symbol3)
	symbol_scenes.append(symbol4)

func create_symbol(symbol_index, pos):
	var symbol = symbol_scenes[symbol_index].instance()
	symbol.position = pos
	main.add_child(symbol)

func collect_symbol(index):
	# the symbols are referred to by 1, 2, 3, 4. 
	# 0 means no symbol on the alien or rock
	collected_symbols[index - 1] = true
	player.symbols_found += 1
	current_symbol += 1
	if current_symbol > 4:
		game_won()
		
func create_explosion(pos):
	var explode = explosion.instance()
	explode.position = pos
	explode.emitting = true
	main.add_child(explode)
		
func game_won():
	get_tree().change_scene("res://scenes/GameOver.tscn")
