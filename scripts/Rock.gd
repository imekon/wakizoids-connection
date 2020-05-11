extends RigidBody2D

export(int) var score = 10

const HEALTH_MAX = 100
const HEALTH_HIT = 60

const THRUST_MIN = 300
const THRUST_RANGE = 200

var health = HEALTH_MAX
var symbol = 0

func _ready():
	var angle = randi() % 360
	var thrust = THRUST_MIN + randi() % THRUST_RANGE
	var impulse = Vector2(thrust, 0).rotated(deg2rad(angle))
	apply_impulse(Vector2(), impulse)

func on_body_entered(body):
	if body.is_in_group("bullets"):
		body.queue_free()
		health -= HEALTH_HIT
		if health < 0:
			Global.player.score += score
			if symbol != 0:
				Global.create_symbol(symbol, global_position)
			queue_free()
