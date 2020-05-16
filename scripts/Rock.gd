extends RigidBody2D

export(int) var score = 10

const HEALTH_MAX = 100
const HEALTH_HIT = 60

const THRUST_MIN = 300
const THRUST_RANGE = 200

var health = HEALTH_MAX
var symbol = 0
var scrape_time = 0

func _ready():
	var angle = randi() % 360
	var thrust = THRUST_MIN + randi() % THRUST_RANGE
	var impulse = Vector2(thrust, 0).rotated(deg2rad(angle))
	apply_impulse(Vector2(), impulse)
	
func _physics_process(delta):
	scrape_time += delta

func on_body_entered(body):
	if body.is_in_group("bullets"):
		body.queue_free()
		health -= HEALTH_HIT
		if health < 0:
			destroyed()
			
	if body.is_in_group("player"):
		if scrape_time > 0.3:
			body.scrape(5)
			scrape_time = 0
		
	if body.is_in_group("aliens"):
		body.queue_free()
		health -= HEALTH_HIT
		if health < 0:
			destroyed()

func destroyed():
	Global.player.score += score
	if symbol != 0:
		Global.create_symbol(symbol, global_position)
	Global.create_explosion(global_position)
	queue_free()
	
