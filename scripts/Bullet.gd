extends KinematicBody2D

const BULLET_THRUST = 1500
const BULLET_TIME_LIMIT = 6

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
	
	var collision = move_and_collide(velocity * delta)
	
	# did we hit anything? note we don't hit rocks here as they are rigid bodies;
	# they work by emitting a signal so they have to handle being hit by a bullet
	if collision != null:
		# deal with aliens
		if collision.collider.is_in_group("aliens"):
			collision.collider.hit()
			queue_free()
		
		# deal with the player
		if collision.collider.is_in_group("player"):
			collision.collider.hit()
			queue_free()
			
		# deal with other bullets
		if collision.collider.is_in_group("bullets"):
			collision.collider.queue_free()
			queue_free()
