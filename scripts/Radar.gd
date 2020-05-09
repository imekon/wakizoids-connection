extends Panel

const RADAR_SCALING = 100
const RADAR_TIME = 0.1

var time = 0

func _process(delta):
	time += delta
	
	if time > RADAR_TIME:
		update()
		time = 0
	
func _draw():
	var player = Global.player
	
	var px = player.global_position.x
	var py = player.global_position.y
	
	var w = rect_size.x
	var h = rect_size.y
	
	var w2 = w / 2 
	var h2 = h / 2
	
	# player position
	var x = w2
	var y = h2
	var rect = Rect2(x - 2, y - 2, 5, 5)
	draw_rect(rect, Color.white)
	
	# rock positions
	var rocks = get_tree().get_nodes_in_group("rocks")
	for rock in rocks:
		x = (rock.global_position.x - px) / RADAR_SCALING + w2
		y = (rock.global_position.y - py) / RADAR_SCALING + h2
		if x < 0:
			continue
			
		if x > w:
			continue
				
		if y < 0:
			continue
			
		if y > h:
			continue
			
		rect = Rect2(x - 1, y - 1, 3, 3)
		draw_rect(rect, Color(0.7, 0, 0))
