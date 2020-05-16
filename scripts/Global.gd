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

var engine_playing = false
var sounds_enabled = true
var music_enabled = true

var symbol_scenes = []
var symbols = []
var collected_symbols = [ false, false, false, false ]
var current_symbol = 0

var music_gain = 0.7
var sound_gain = 0.7
var player_score = 0
var high_score = 0

func _ready():
	symbol_scenes.append(symbol1)
	symbol_scenes.append(symbol2)
	symbol_scenes.append(symbol3)
	symbol_scenes.append(symbol4)
	
func convert_gain_to_db(gain):
	if gain < 0.0:
		return -90.0
	else:
		return 20.0 * log(gain) / log(10)

func create_symbol(symbol_index, pos):
	# the symbols are referred to by 1, 2, 3, 4. 
	# 0 means no symbol on the alien or rock
	var symbol = symbol_scenes[symbol_index - 1].instance()
	symbol.position = pos
	main.add_child(symbol)

func collect_symbol(index):
	# the symbols are referred to by 1, 2, 3, 4. 
	# 0 means no symbol on the alien or rock
	player.score += 1000

	collected_symbols[index - 1] = true
	player.symbols_found += 1
	current_symbol += 1
	
	while current_symbol < 4 && collected_symbols[current_symbol]:
		current_symbol += 1
		
	main.play_pickup_sound()
	if current_symbol >= 4:
		game_won()
		
func create_explosion(pos):
	var explode = explosion.instance()
	explode.position = pos
	explode.emitting = true
	main.add_child(explode)
	
	if (sounds_enabled):
		main.play_explosion_sound()
	
func play_engine_sound():
	if !sounds_enabled:
		return
		
	if engine_playing:
		return
		
	main.play_engine_sound()
	engine_playing = true
	
func stop_engine_sound():
	if !sounds_enabled:
		return

	if !engine_playing:
		return
		
	main.stop_engine_sound()
	engine_playing = false
		
func game_won():
	player_score = player.score
	if player.score > high_score:
		high_score = player.score
	get_tree().change_scene("res://scenes/GameOver.tscn")

func game_lost():
	player_score = player.score
	if player.score > high_score:
		high_score = player.score
	main.play_explosion_sound()
	get_tree().change_scene("res://scenes/GameLost.tscn")
