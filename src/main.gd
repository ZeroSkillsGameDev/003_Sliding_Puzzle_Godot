extends Area2D

var tiles = []
var solved = []
var mouse = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()

func start_game():
	tiles = [$Tile1, $Tile2, $Tile3, $Tile4, $Tile5, $Tile6, $Tile7, $Tile8, $Tile9, $Tile10, $Tile11, $Tile12, $Tile13, $Tile14, $Tile15, $Tile16 ]
	solved = tiles.duplicate()
	shuffle_tiles()
	
func shuffle_tiles():
	var previous = 99
	var previous_1 = 98
	for t in range(0,1000):
		var tile = randi() % 16
		if tiles[tile] != $Tile16 and tile != previous and tile != previous_1:
			var rows = int(tiles[tile].position.y / 250)
			var cols = int(tiles[tile].position.x / 250)
			check_neighbours(rows,cols)
			previous_1 = previous
			previous = tile
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy = mouse
		print(mouse.position)
		mouse = false
		var rows = int(mouse_copy.position.y / 250)
		var cols = int(mouse_copy.position.x / 250)
		check_neighbours(rows,cols)
		if tiles == solved:
			print("You win!")

func check_neighbours(rows, cols):
	var empty = false
	var done = false
	var pos = rows * 4 + cols
	while !empty and !done:
		var new_pos = tiles[pos].position
		if rows < 3:
			new_pos.y += 250
			empty = find_empty(new_pos,pos)
			new_pos.y -= 250
		if rows > 0:
			new_pos.y -= 250
			empty = find_empty(new_pos,pos)
			new_pos.y += 250
		if cols < 3:
			new_pos.x += 250
			empty = find_empty(new_pos,pos)
			new_pos.x -= 250
		if cols > 0:
			new_pos.x -= 250
			empty = find_empty(new_pos,pos)
			new_pos.x += 250
		done = true
			
func find_empty(position,pos):
	var new_rows = int(position.y / 250)
	var new_cols = int(position.x / 250)
	var new_pos = new_rows * 4 + new_cols
	if tiles[new_pos] == $Tile16:
		swap_tiles(pos, new_pos)
		return true
	else:
		return false

func swap_tiles(tile_src, tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos
	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = temp_tile
	
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		mouse = event
