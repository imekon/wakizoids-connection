extends Panel

const RADAR_TIME = 0.1
const RADAR_VERT_OFFSET = 20
const SYMBOL_COLOUR = Color(0, 0, 1)

var time = 0
var scaling = 100

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
	var h = rect_size.y - RADAR_VERT_OFFSET
	
	var w2 = w / 2 
	var h2 = h / 2
	
#	var gray_colour = Color(0.7, 0.7, 0.7)
	
	# player position
	var x = w2
	var y = h2 + RADAR_VERT_OFFSET
	var rect = Rect2(x - 2, y - 2, 5, 5)
	draw_rect(rect, Color.white)
	
	# current symbol
	var current_symbol_item = Global.symbols[Global.current_symbol - 1]
	
	var draw_anyway = false
	var colour = Color(1, 0, 0)

	# rock positions
	var rocks = get_tree().get_nodes_in_group("rocks")
	for rock in rocks:
		draw_anyway = false
		colour = Color.green
		
		x = (rock.global_position.x - px) / scaling + w2
		y = (rock.global_position.y - py) / scaling + h2 + RADAR_VERT_OFFSET

#		var colour = Color(0, 0.7, 0)
		if rock == current_symbol_item:
			colour = SYMBOL_COLOUR
			draw_anyway = true
			
		if x < 0:
			if draw_anyway:
				x = 0
			else:
				continue
			
		if x > w:
			if draw_anyway:
				x = w
			else:
				continue
				
		if y < RADAR_VERT_OFFSET:
			if draw_anyway:
				y = RADAR_VERT_OFFSET
			else:
				continue
			
		if y > h:
			if draw_anyway:
				y = h
			else:
				continue
			
		rect = Rect2(x - 1, y - 1, 3, 3)
		draw_rect(rect, colour)
		
	# alien positions
	var aliens = get_tree().get_nodes_in_group("aliens")
	for alien in aliens:
		draw_anyway = false
		colour = Color.red
		
		x = (alien.global_position.x - px) / scaling + w2
		y = (alien.global_position.y - py) / scaling + h2 + RADAR_VERT_OFFSET

		colour = Color(0.7, 0, 0)
		if alien == current_symbol_item:
			colour = SYMBOL_COLOUR
			draw_anyway = true

		if x < 0:
			if draw_anyway:
				x = 0
			else:
				continue
			
		if x > w:
			if draw_anyway:
				x = w
			else:
				continue
				
		if y < RADAR_VERT_OFFSET:
			if draw_anyway:
				y = RADAR_VERT_OFFSET
			else:
				continue
			
		if y > h:
			if draw_anyway:
				y = h
			else:
				continue
			
		rect = Rect2(x - 1, y - 1, 3, 3)
		draw_rect(rect, colour)

	# symbols
	var symbols = get_tree().get_nodes_in_group("symbols")
	for symbol in symbols:
		x = (symbol.global_position.x - px) / scaling + w2
		y = (symbol.global_position.y - py) / scaling + h2 + RADAR_VERT_OFFSET
		if x < 0:
			x = 0
			
		if x > w:
			x = w
				
		if y < RADAR_VERT_OFFSET:
			y = RADAR_VERT_OFFSET
			
		if y > h:
			y = h
			
		rect = Rect2(x - 2, y - 2, 5, 5)
		draw_rect(rect, SYMBOL_COLOUR)

func set_range(radar_range):
	match radar_range:
		0:
			scaling = 50
		1:
			scaling = 100
		2:
			scaling = 200
