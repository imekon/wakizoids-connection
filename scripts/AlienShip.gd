extends KinematicBody2D

export(int) var alien_ship

onready var proximity_position = $ProximityPosition

enum STATE { Stopped, Moving }

var symbol = 0
var velocity = Vector2()
var thrust
var state = STATE.Moving

func _ready():
	thrust = 200 + randi() % 400
	
func _physics_process(delta):
	match state:
		STATE.Moving:
			process_moving(delta)
		STATE.Stopped:
			pass
			
func process_moving(delta):
	if check_proximity():
		return
		
	check_edge_universe()
	
	velocity = Vector2(thrust, 0).rotated(deg2rad(rotation_degrees - 90))
	move_and_collide(velocity * delta)

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
		state = STATE.Stopped
		return true
		
	return false
