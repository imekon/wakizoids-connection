extends RigidBody2D

var health = 100

func _physics_process(delta):
	if health < 0:
		rock_destroyed()
		
func hit():
	health -= 30
	
func rock_destroyed():
	Global.player.score += 10
	queue_free()
	
