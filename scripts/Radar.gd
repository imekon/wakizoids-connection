extends Panel

const RADAR_SCALING = 100
const RADAR_TIME = 0.1
const RADAR_VERT_OFFSET = 20

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
	var h = rect_size.y - 20
	
	var w2 = w / 2 
	var h2 = h / 2
	
#	var gray_colour = Color(0.7, 0.7, 0.7)
	
	# player position
	var x = w2
	var y = h2 + RADAR_VERT_OFFSET
	var rect = Rect2(x - 2, y - 2, 5, 5)
	draw_rect(rect, Color.white)
	
	# current symbol
	var current_symbol_item = Global.symbols[Global.current_symbol]
	
	# rock positions
	var rocks = get_tree().get_nodes_in_group("rocks")
	for rock in rocks:
		x = (rock.global_position.x - px) / RADAR_SCALING + w2
		y = (rock.global_position.y - py) / RADAR_SCALING + h2 + RADAR_VERT_OFFSET
		if x < 0:
			continue
			
		if x > w:
			continue
				
		if y < RADAR_VERT_OFFSET:
			continue
			
		if y > h:
			continue
			
		rect = Rect2(x - 1, y - 1, 3, 3)
		var colour = Color(0, 0.7, 0)
		if rock == current_symbol_item:
			colour = Color.yellow
			
		draw_rect(rect, colour)

	# alien positions
	var aliens = get_tree().get_nodes_in_group("aliens")
	for alien in aliens:
		x = (alien.global_position.x - px) / RADAR_SCALING + w2
		y = (alien.global_position.y - py) / RADAR_SCALING + h2 + RADAR_VERT_OFFSET
		if x < 0:
			continue
			
		if x > w:
			continue
				
		if y < RADAR_VERT_OFFSET:
			continue
			
		if y > h:
			continue
			
		rect = Rect2(x - 1, y - 1, 3, 3)
		var colour = Color(0.7, 0, 0)
		if alien == current_symbol_item:
			colour = Color.yellow
			
		draw_rect(rect, colour)

	# symbols
	var symbols = get_tree().get_nodes_in_group("symbols")
	for symbol in symbols:
		x = (symbol.global_position.x - px) / RADAR_SCALING + w2
		y = (symbol.global_position.y - py) / RADAR_SCALING + h2 + RADAR_VERT_OFFSET
		if x < 0:
			continue
			
		if x > w:
			continue
				
		if y < RADAR_VERT_OFFSET:
			continue
			
		if y > h:
			continue
			
		rect = Rect2(x - 1, y - 1, 3, 3)
		draw_rect(rect, Color.yellow)
