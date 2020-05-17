extends Node2D

onready var shields_label = $PlayerShip/HUD/ShieldsLabel
onready var health_label = $PlayerShip/HUD/HealthLabel
onready var score_label = $PlayerShip/HUD/ScoreLabel
onready var thrust_label = $PlayerShip/HUD/ThrustLabel
onready var rock_label = $PlayerShip/HUD/RockLabel
onready var alien_label = $PlayerShip/HUD/AlienLabel
onready var symbols_label = $PlayerShip/HUD/SymbolLabel
onready var reminder_label = $PlayerShip/HUD/ReminderLabel
onready var reminder_tween = $PlayerShip/HUD/ReminderLabel/Tween

onready var radar = $PlayerShip/HUD/Radar

onready var tween = $SoundEffects/Tween
onready var alarm_sound = $SoundEffects/Alarm
onready var engine_sound = $SoundEffects/Engine
onready var explosion_sound = $SoundEffects/Explosion
onready var fire_sound = $SoundEffects/Fire
onready var pickup_sound = $SoundEffects/Pickup

onready var music1 = $Music/Music1
onready var music2 = $Music/Music2

onready var player = $PlayerShip

onready var rock1 = preload("res://scenes/Rock1.tscn")
onready var rock2 = preload("res://scenes/Rock2.tscn")
onready var rock3 = preload("res://scenes/Rock3.tscn")
onready var rock4 = preload("res://scenes/Rock4.tscn")
onready var rock5 = preload("res://scenes/Rock5.tscn")
onready var rock6 = preload("res://scenes/Rock6.tscn")

onready var alien1 = preload("res://scenes/Alien1.tscn")
onready var alien2 = preload("res://scenes/Alien2.tscn")
onready var alien3 = preload("res://scenes/Alien3.tscn")
onready var alien4 = preload("res://scenes/Alien4.tscn")

onready var bullet_scene = preload("res://scenes/Bullet.tscn")

const BULLET_REPEAT_TIME = 0.2

# enum SOUNDS { Alarm, EngineSound, Explosion, Fire, Pickup }

var bullet_time = 0
var escape_time = 0
var tween_stop

func _ready():
	Global.player = player
	Global.main = self
	
	Global.reset_symbols()
	
	var items = []
	build_rocks(items)
	build_aliens(items)
	
	for i in range(0, 4):
		var flag = true
		while flag:
			var index = randi() % items.size()
			if items[index].symbol != 0:
				continue
			
			print("symbol %d at %d" % [i, index])
			items[index].symbol = i + 1
			Global.symbols.append(items[index])
			flag = false
			
	if Global.symbols.size() != 4:
		print("not enough symbols!")
	
	if Global.music_enabled:
		if randi() % 100 > 50:
			music2.play()
		else:
			music1.play()
			
	reminder_tween.interpolate_property(reminder_label, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 5, Tween.TRANS_QUAD, Tween.EASE_IN)
	reminder_tween.start()
			
func _physics_process(delta):
	var rock_count = get_tree().get_nodes_in_group("rocks").size()
	var alien_count = get_tree().get_nodes_in_group("aliens").size()
	
	shields_label.text = "Shields: %d" % player.shields
	health_label.text = "Health: %d" % player.health
	score_label.text = "Score: %d High score: %d" % [ player.score, Global.high_score ]
	thrust_label.text = "Thrust: %d" % player.thrust
	rock_label.text = "Rocks: %d" % rock_count
	alien_label.text = "Aliens: %d" % alien_count
	symbols_label.text = "Symbols: %d/4" % player.symbols_found
	
	bullet_time += delta
	escape_time += delta
	
	if Input.is_action_pressed("fire"):
		fire_bullet(player.firing_position.global_position, player.angle)
		
	if Input.is_action_just_pressed("escape"):
		process_escape(delta)
		
	if Input.is_action_just_pressed("short_range"):
		radar.set_range(0)
		
	if Input.is_action_just_pressed("medium_range"):
		radar.set_range(1)
		
	if Input.is_action_just_pressed("long_range"):
		radar.set_range(2)
		
func process_escape(delta):
	if escape_time > 10:
		get_tree().change_scene("res://scenes/Welcome.tscn")

func build_rocks(items):
	var rock
	for _i in range(0, 20):
		rock = build_rock(rock1)
		items.append(rock)
		rock = build_rock(rock2)
		items.append(rock)
		rock = build_rock(rock3)
		items.append(rock)
		rock = build_rock(rock4)
		items.append(rock)
		rock = build_rock(rock5)
		items.append(rock)
		rock = build_rock(rock6)
		items.append(rock)
		
func build_rock(rock_scene):
	var x = randi() % Global.EDGE_UNIVERSE2 - Global.EDGE_UNIVERSE
	var y = randi() % Global.EDGE_UNIVERSE2 - Global.EDGE_UNIVERSE
	var rock = rock_scene.instance()
	rock.position = Vector2(x, y)
	add_child(rock)
	return rock
	
func build_aliens(items):
	var alien
	for _i in range(0, 20):
		alien = build_alien(alien1)
		items.append(alien)
		alien = build_alien(alien2)
		items.append(alien)
		alien = build_alien(alien3)
		items.append(alien)
		alien = build_alien(alien4)
		items.append(alien)
	
func build_alien(alien_scene):
	var x = randi() % Global.EDGE_UNIVERSE2 - Global.EDGE_UNIVERSE
	var y = randi() % Global.EDGE_UNIVERSE2 - Global.EDGE_UNIVERSE
	var alien = alien_scene.instance()
	alien.position = Vector2(x, y)
	alien.rotation_degrees = randi() % 360
	add_child(alien)
	return alien

func fire_bullet(pos, angle):
	if bullet_time < BULLET_REPEAT_TIME:
		return
		
	if Global.sounds_enabled:
		fire_sound.play()
		
	var bullet = bullet_scene.instance()
	bullet.global_position = pos
	bullet.angle = angle
	add_child(bullet)
	bullet_time = 0

func play_engine_sound():
	tween_stop = false
	tween.interpolate_property(engine_sound, "volume_db", -60, 0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	engine_sound.play()
	
func stop_engine_sound():
	tween_stop = true
	tween.interpolate_property(engine_sound, "volume_db", 0, -60, 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func play_explosion_sound():
	explosion_sound.play()

func play_pickup_sound():
	pickup_sound.play()

func on_tween_completed(_object, _key):
	if tween_stop:
		engine_sound.stop()
