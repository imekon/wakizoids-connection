# TARGETING HELPER

extends Node

var target
var target_position
var target_angle
var last_fired

class_name Targeting

func _init():
	target = null
	target_position = Vector2(0, 0)
	target_angle = 0
	last_fired = 0
	
func clear():
	target = null

func set_target(delta, what):
	last_fired += delta
	target = weakref(what)

func plot_course_to_target(delta, ship_position):
	if target == null:
		last_fired += delta
		return false
	
	if !target.get_ref():
		last_fired += delta
		target = null
		return false
		
	target_position = target.get_ref().global_position
	target_angle = rad2deg(target_position.angle_to_point(ship_position)) + 90
	return true

func is_target(what):
	if target != null:
		if target.get_ref() == what:
			return true
			
	return false
	
