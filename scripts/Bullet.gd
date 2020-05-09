extends KinematicBody2D

const BULLET_THRUST = 1000
const BULLET_TIME_LIMIT = 2

var angle = 0
var velocity = Vector2(0, 0)
var time = 0

func _physics_process(delta):
	time += delta
	
	if time > BULLET_TIME_LIMIT:
		queue_free()
		return
	
	velocity.x = BULLET_THRUST * sin(deg2rad(angle))
	velocity.y = -BULLET_THRUST * cos(deg2rad(angle))

	velocity = move_and_slide(velocity)
	
	for i in range(0, get_slide_count()):
		var body = get_slide_collision(i).collider
		if body.is_in_group("rocks"):
			body.hit()
			queue_free()
			break
