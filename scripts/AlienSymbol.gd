extends RigidBody2D

export(int) var symbol_tag

onready var sprite = $Sprite
onready var tween = $Tween

const SYMBOL_GLOW_UP_TIME = 2
const SYMBOL_GLOW_DOWN_TIME = 1

var dead = false

func on_body_entered(body):
	if dead:
		return
		
	if body.is_in_group("aliens"):
		print("alien destroyed symbol, chance of peace non-existant")
		glow_symbol()
		
	if body.is_in_group("player"):
		Global.collect_symbol(symbol_tag)
		glow_symbol()
		
	if body.is_in_group("bullets"):
		body.queue_free()

func glow_symbol():
	dead = true
	
	tween.interpolate_property(sprite, "modulate", Color(1, 1, 1), Color(1.5, 1, 1), SYMBOL_GLOW_UP_TIME, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(sprite, "modulate", Color(1.5, 1, 1), Color(1, 1, 1), SYMBOL_GLOW_UP_TIME, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
