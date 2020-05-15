extends KinematicBody2D

export(int) var alien_ship
export(int) var health = 100
export(int) var score = 20

onready var proximity_position = $ProximityPosition
onready var firing_position = $FiringPosition

onready var bullet_scene = load("res://scenes/Bullet.tscn")

enum STATE { Stopped, Drifting, Target, Turning, Moving, TurningToShoot, Firing }

const MOVEMENT = 200

var symbol = 0
var velocity = Vector2()
var thrust
var state = STATE.Drifting
var stop_time
var stop_timeout
var targeting
var last_fired = 0
var firing_count = 0

func _ready():
	thrust = 200 + randi() % 400
	targeting = Targeting.new()
	
func _physics_process(delta):
	match state:
		STATE.Moving:
			process_moving(delta)
		STATE.Drifting:
			process_drifting(delta)
		STATE.Target:
			process_targeting(delta)
		STATE.Turning:
			process_turning(delta)
		STATE.TurningToShoot:
			process_turning_to_shoot(delta)
		STATE.Firing:
			process_firing(delta)
		STATE.Stopped:
			process_stopped(delta)
			
func process_moving(delta):
	if check_proximity():
		state = STATE.Stopped
		stop_time = 0
		stop_timeout = 5 + randi() % 4
		return
		
	check_edge_universe()
	
	velocity = Vector2(0, -thrust).rotated(rotation)
	move_and_collide(velocity * delta)
	
	# Are we targeting the player, are we in range, if so FIRE!!!
	
func process_drifting(delta):
	if check_proximity():
		state = STATE.Stopped
		stop_time = 0
		stop_timeout = 5 + randi() % 4
		return
		
	check_edge_universe()
	
	thrust = MOVEMENT * delta
	var direction = Vector2(0, -thrust).rotated(rotation)
	move_and_collide(direction)
	
func process_targeting(delta):
	var closest_distance = 99999
	var closest_ship = null
	var distance = global_position.distance_to(Global.player.global_position)
	if distance < closest_distance:
		closest_distance = distance
		closest_ship = Global.player
		
	if closest_distance > 10000:
		state = STATE.Drifting
		return
		
	if closest_ship == null:
		state = STATE.Drifting
		return
		
	targeting.set_target(delta, Global.player)
	targeting.plot_course_to_target(delta, global_position)
	state = STATE.Turning
	
func process_turning(delta):
	if !targeting.plot_course_to_target(delta, global_position):
		return
		
	var angle_delta
	if targeting.target_angle > rotation_degrees:
		angle_delta = 1
	else:
		angle_delta = -1
		
	if abs(rotation_degrees - targeting.target_angle) > 1:
		rotate(deg2rad(angle_delta))
	else:
		state = STATE.Moving
	
func process_turning_to_shoot(delta):
	if !targeting.plot_course_to_target(global_position):
		return
		
	var angle_delta
	
	if targeting.target_angle > rotation_degrees:
		angle_delta = 1
	else:
		angle_delta = -1
		
	if abs(rotation_degrees - targeting.target_angle) > 1:
		rotate(deg2rad(angle_delta))
	else:
		last_fired = delta
		state = STATE.Firing
	
func process_firing(delta):
	var now = last_fired + delta
	if now > 0.1:
		var bullet = bullet_scene.instance()
		bullet.position = firing_position.global_position
		bullet.rotate(rotation)
		get_parent().add_child(bullet)
		last_fired = now
		firing_count += 1

	if firing_count > 5:
		state = STATE.Target
		targeting.clear()
	
func process_stopped(delta):
	stop_time += delta
	if stop_time > stop_timeout:
		state = STATE.Moving

func check_edge_universe():
	var x = global_position.x
	var y = global_position.y
	
	if x > -Global.EDGE_UNIVERSE && x < Global.EDGE_UNIVERSE && y > -Global.EDGE_UNIVERSE && y < Global.EDGE_UNIVERSE:
		return
		
	rotation_degrees -= 180 + randi() % 30

func check_proximity():
	var space = get_world_2d().direct_space_state
	var result = space.intersect_ray(global_position, proximity_position.global_position, [self])
	if result:
		return true
		
	return false

func hit():
	health -= 30
	if health < 0:
		destroyed()
		
	state = STATE.Target

func destroyed():
	Global.player.score += 20
	if symbol != 0:
		Global.create_symbol(symbol, global_position)
	Global.create_explosion(global_position)
	queue_free()
	
