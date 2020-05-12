extends KinematicBody2D

export(int) var alien_ship
export(int) var health = 100
export(int) var score = 20

onready var proximity_position = $ProximityPosition

enum STATE { Stopped, Drifting, Target, Turning, Moving, TurningToShoot, Firing }

const MOVEMENT = 200

var symbol = 0
var velocity = Vector2()
var thrust
var state = STATE.Moving
var stop_time
var stop_timeout
var targeting

func _ready():
	thrust = 200 + randi() % 400
	
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
	
	velocity = Vector2(thrust, 0).rotated(deg2rad(rotation_degrees - 90))
	move_and_collide(velocity * delta)
	
func process_drifting(delta):
	check_edge_universe()
	
	thrust = MOVEMENT * delta
	var direction = Vector2(thrust, 0).rotated(deg2rad(rotation_degrees - 90))
	move_and_collide(direction)
	
func process_targeting(delta):
	pass
	
func process_turning(delta):
	pass
	
func process_turning_to_shoot(delta):
	pass
	
func process_firing(delta):
	pass
	
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

func destroyed():
	Global.player.score += 20
	if symbol != 0:
		Global.create_symbol(symbol, global_position)
	Global.create_explosion(global_position)
	queue_free()
	
