extends Node

const EDGE_UNIVERSE = 10000

onready var symbol1 = preload("res://scenes/Symbol1.tscn")
onready var symbol2 = preload("res://scenes/Symbol2.tscn")
onready var symbol3 = preload("res://scenes/Symbol3.tscn")
onready var symbol4 = preload("res://scenes/Symbol4.tscn")

var player
var main

var symbols = []

func _ready():
	symbols.append(symbol1)
	symbols.append(symbol2)
	symbols.append(symbol3)
	symbols.append(symbol4)

func create_symbol(symbol_index, pos):
	var symbol = symbols[symbol_index].instance()
	symbol.position = pos
	main.add_child(symbol)
