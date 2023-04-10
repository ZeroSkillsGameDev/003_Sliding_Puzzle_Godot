extends Area2D

var mouse
var tiles = []
var solved = []
var counter = 0

func _ready():
	start_game()

func start_game():
	$Label.hide()
	tiles = [$Tile1, $Tile2, $Tile3, $Tile4, $Tile5, $Tile6, $Tile7, $Tile8, $Tile9, $Tile10, $Tile11, $Tile12, $Tile13, $Tile14, $Tile15, $Tile16]
	solved = tiles.duplicate()
	shuffle_tiles()
	counter = 0

func shuffle_tiles():
	for u in range(0,100):
		var tile_a = randi() % 16
		if tiles[tile_a] != $Tile16:
			var rows = int(tiles[tile_a].position.y / 250)
			var cols = int(tiles[tile_a].position.x / 250)
			check_neighbours(rows,cols)

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy = mouse
		mouse = false
		var rows = int(mouse_copy.position.y / 250)
		var cols = int(mouse_copy.position.x / 250)
		check_neighbours(rows,cols)
		if tiles == solved:
			$Label.text = "YOU WON \n in " + str(counter) + "\n movements"
			$Label.show()
				

func check_neighbours(rows,cols):
	var tile_pos = rows * 4 + cols
	var empty = false
	var done = false
	while !empty and !done:
		var new_pos = tiles[tile_pos].position
		if rows < 3:
			new_pos.y += 250
			empty = find_empty(new_pos,tile_pos)
			new_pos.y -= 250
		if rows > 0:
			new_pos.y -= 250
			empty = find_empty(new_pos,tile_pos)
			new_pos.y += 250
		if cols < 3:
			new_pos.x += 250
			empty = find_empty(new_pos,tile_pos)
			new_pos.x -= 250
		if cols > 0:
			new_pos.x -= 250
			empty = find_empty(new_pos,tile_pos)
			new_pos.x += 250
		done = true

func find_empty(position,tile_pos):
	var new_rows = int(position.y / 250)
	var new_cols = int(position.x / 250)
	var new_pos = new_rows * 4 + new_cols
	if tiles[new_pos] == $Tile16:
		swap_tiles(tile_pos,new_pos)
		return true
	else:
		return false


func swap_tiles(tile_src,tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos
	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = temp_tile
	counter += 1


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		mouse = event
