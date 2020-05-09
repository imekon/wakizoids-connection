extends KinematicBody2D

onready var firing_position = $FiringPosition
onready var exhaust_position = $ExhaustPosition

const ROTATION_SPEED = 1
const THRUST_SPEED = 10
const THRUST_DECAY = 3
const THRUST_BRAKE = 6
const THRUST_MAX = 700

var angle = 0
var thrust = 0
var velocity = Vector2()
var score = 0

func _physics_process(delta):
	thrust -= THRUST_DECAY
	
	if Input.is_action_pressed("left"):
		angle -= ROTATION_SPEED
		
	if Input.is_action_pressed("right"):
		angle += ROTATION_SPEED
		
	if Input.is_action_pressed("thrust"):
		thrust += THRUST_SPEED
		
	if Input.is_action_pressed("brake"):
		thrust -= THRUST_BRAKE

	thrust = clamp(thrust, 0, THRUST_MAX)
		
	velocity.x = thrust * sin(deg2rad(angle))
	velocity.y = -thrust * cos(deg2rad(angle))
		
	rotation_degrees = angle
	velocity = move_and_slide(velocity)
