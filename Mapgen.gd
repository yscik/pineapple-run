
var blocksize = 110
var game

var action_chance = 0.1
var good_action_percent = 0.75

var max_offset
var previous_offset = { top = 0, bottom = 0}

func _init(game):
	self.game = game
	update_height()
	
	for i in range(20):
		add_row(11 + i)
	pass
	
	print("height", int(game.height / blocksize / 2))

var last_row = 0
func update():
	
	update_height()
	if game.pos / blocksize > last_row - 20:
		add_row(last_row + 1)
		
	
func update_height():
	max_offset = int(game.height / blocksize / 2) + 1

var ItemScene = preload("res://Item.tscn")

func add_row(row):	

	var wall = "top" if randf() > 0.6 else "bottom"
	var count = min(previous_offset[wall] + 2, max(previous_offset[wall] - 2, max(0, randi() % (max_offset+1))))
	
	for i in range(count):
		add_item(row, wall, i)
	previous_offset[wall] = count
	last_row = row

func add_item(row, wall, offset):
	var container = game.walls[wall].get_node("Items")
	var offset_direction = 1 if wall == "top" else -1
	var item = ItemScene.instance()
	
	if randf() < action_chance + (0.5 / max_offset):
		var good_action = randf() < good_action_percent
		item.is_good = good_action
		item.action = "up1" if ((wall == "top" && good_action) || (wall == "bottom" && !good_action)) else "down1"
	
	item.position = Vector2(row * blocksize, offset * blocksize * offset_direction)
	item.wall = wall
	item.offset = offset
	
	container.add_child(item)
	