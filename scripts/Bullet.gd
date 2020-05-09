extends KinematicBody2D

const BULLET_THRUST = 1000
const BULLET_TIME_LIMIT = 2

var angle = 0
var velocity = Vector2(0, 0)
var time = 0

func _ready():
	rotation_degrees = angle
	velocity = Vector2(BULLET_THRUST, 0).rotated(deg2rad(angle - 90))

func _physics_process(delta):
	time += delta
	
	if time > BULLET_TIME_LIMIT:
		queue_free()
		return
	
	move_and_slide(velocity)
