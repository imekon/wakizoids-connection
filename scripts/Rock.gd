extends RigidBody2D

const HEALTH_MAX = 100
const HEALTH_HIT = 60

var health = HEALTH_MAX
var symbol = 0

func on_body_entered(body):
	if body.is_in_group("bullets"):
		body.queue_free()
		health -= HEALTH_HIT
		if health < 0:
			Global.player.score += 10
			queue_free()
