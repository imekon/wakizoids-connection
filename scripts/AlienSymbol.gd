extends RigidBody2D

export(int) var symbol_tag

func _ready():
	pass

func on_body_entered(body):
	if body.is_in_group("player"):
		Global.collect_symbol(symbol_tag)
		queue_free()
		
	if body.is_in_group("bullets"):
		body.queue_free()

