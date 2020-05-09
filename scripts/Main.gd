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
	
	build_rocks()
	build_aliens()

func _physics_process(delta):
	score_label.text = "Score: " + str(player.score)
	thrust_label.text = "Thrust: " + str(player.thrust)
	
	bullet_time += delta
	
	if Input.is_action_pressed("fire"):
		fire_bullet(player.firing_position.global_position, player.angle)

func build_rocks():
	for i in range(0, 20):
		build_rock(rock1)
		build_rock(rock2)
		build_rock(rock3)
		build_rock(rock4)
		build_rock(rock5)
		build_rock(rock6)
		
func build_rock(rock_scene):
	var x = randi() % 20000 - 10000
	var y = randi() % 20000 - 10000
	var rock = rock_scene.instance()
	rock.position = Vector2(x, y)
	add_child(rock)
	
func build_aliens():
	for i in range(0, 20):
		build_alien(alien1)
		build_alien(alien2)
		build_alien(alien3)
		build_alien(alien4)
	
func build_alien(alien_scene):
	var x = randi() % 20000 - 10000
	var y = randi() % 20000 - 10000
	var alien = alien_scene.instance()
	alien.position = Vector2(x, y)
	alien.rotation_degrees = randi() % 360
	add_child(alien)

func fire_bullet(pos, angle):
	if bullet_time < BULLET_REPEAT_TIME:
		return
		
	var bullet = bullet_scene.instance()
	bullet.global_position = pos
	bullet.angle = angle
	add_child(bullet)
	bullet_time = 0
