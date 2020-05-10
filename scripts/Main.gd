extends Node2D

onready var score_label = $PlayerShip/HUD/ScoreLabel
onready var thrust_label = $PlayerShip/HUD/ThrustLabel

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

onready var symbol1 = preload("res://scenes/Symbol1.tscn")
onready var symbol2 = preload("res://scenes/Symbol2.tscn")
onready var symbol3 = preload("res://scenes/Symbol3.tscn")
onready var symbol4 = preload("res://scenes/Symbol4.tscn")

onready var bullet_scene = preload("res://scenes/Bullet.tscn")

const BULLET_REPEAT_TIME = 0.2

var bullet_time = 0

func _ready():
	randomize()
	
	Global.player = player
	
	var items = []
	build_rocks(items)
	build_aliens(items)
	
	for i in range(0, 4):
		var flag = true
		while flag:
			var index = randi() % items.size()
			if items[index].symbol != 0:
				continue
				
			items[index].symbol = i + 1
			print("symbol set at " + str(index))
			flag = false
			
func _physics_process(delta):
	score_label.text = "Score: " + str(player.score)
	thrust_label.text = "Thrust: " + str(player.thrust)
	
	bullet_time += delta
	
	if Input.is_action_pressed("fire"):
		fire_bullet(player.firing_position.global_position, player.angle)

func build_rocks(items):
	var rock
	for i in range(0, 20):
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
	var x = randi() % 20000 - 10000
	var y = randi() % 20000 - 10000
	var rock = rock_scene.instance()
	rock.position = Vector2(x, y)
	add_child(rock)
	return rock
	
func build_aliens(items):
	var alien
	for i in range(0, 20):
		alien = build_alien(alien1)
		items.append(alien)
		alien = build_alien(alien2)
		items.append(alien)
		alien = build_alien(alien3)
		items.append(alien)
		alien = build_alien(alien4)
		items.append(alien)
	
func build_alien(alien_scene):
	var x = randi() % 20000 - 10000
	var y = randi() % 20000 - 10000
	var alien = alien_scene.instance()
	alien.position = Vector2(x, y)
	alien.rotation_degrees = randi() % 360
	add_child(alien)
	return alien

func fire_bullet(pos, angle):
	if bullet_time < BULLET_REPEAT_TIME:
		return
		
	var bullet = bullet_scene.instance()
	bullet.global_position = pos
	bullet.angle = angle
	add_child(bullet)
	bullet_time = 0
