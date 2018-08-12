extends Node2D

var running = true
var height

var mapgen
var wall_speed
var score

func _ready():
	
	randomize()
	wall_speed = 11.0
	height = level_height()
	mapgen = load("res://Mapgen.gd").new(self)
	set_process_input(true)
	pass

onready var walls = {
	top = get_node("Ceiling"),
	bottom = get_node("Floor")
}

func move_wall(node, d):
	node.position.y += d
	
	
var colors = {
	good = Color("#386eed"),
	bad = Color("#e20f3b"),
	normal = Color("#090909"),
}	

func wall_action(wall, is_good):
	var d = -1 if wall == "top" else 1
	d *=  1 if is_good else -1
	
	var wallNode = walls[wall] 
	move_wall(wallNode, d * 20)

	var wallSprite = wallNode.get_node("Fixed/Wall")
	var tween = wallNode.get_node("Tween")
	tween.interpolate_property(wallSprite, "modulate", colors["good" if is_good else "bad"], colors.normal, 0.5,
		Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(wallSprite, "rotation_degrees", 1 * d, 0, 0.5,
		Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()

func _physics_process(delta):
	
	if !running: return
	
	move_wall(walls.top, wall_speed * delta)
	move_wall(walls.bottom, -wall_speed * delta)

	world_move(delta)
	$Bullets.lastBullet += delta
	if $Player.input.fire:
		$Bullets.shoot()
	
	height = level_height()
	
	if(!$Player.dead && height < 190):
		$Player.visible = false
		$Ceiling/Items.visible = false
		$Floor/Items.visible = false
		$Bullets.visible = false
		wall_speed = 100
	if(height <= 10):
		
		end()
		
	mapgen.update()
	
var pos = 0

func world_move(delta):
	
	pos = $Player.global_position.x
		
	$Ceiling/Fixed.position.x = pos
	$Floor/Fixed.position.x = pos

	score = String(round(pos / 300))
	$HUD/Score.text = score

func level_height():
	return $Floor.global_position.y - $Ceiling.global_position.y 
	
	
func end():
	running = false
	$Music.stop()
	$UI.gameover()
	$UI/Menu/Screens/Dead/Score.text = score + " points"
	pass

	