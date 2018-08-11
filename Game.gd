extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var running = true

func _ready():
	set_process_input(true)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

onready var walls = {
	top = get_node("Ceiling"),
	bottom = get_node("Floor")
}

var bulletScn = preload("res://Bullet.tscn")
var lastBullet = 1
func shoot(delta):
	
	if(lastBullet < 0.1): 
		return
	
	var mousePos = get_viewport().get_mouse_position()
	var playerPos = $Player.global_position
	var direction =  (mousePos - playerPos).normalized()
	if(direction.x < 0): return

	lastBullet = 0
		
	var bullet = bulletScn.instance()
	bullet.global_position = playerPos + Vector2(30,0)
	
	bullet.v = direction * 500
	$Bullets.add_child(bullet)
	bullet.apply_impulse(Vector2(0,0), bullet.v)
	bullet.connect("body_entered", self, "hit", [bullet])
	
func hit(item, bullet): 
	bullet.queue_free()
	
	if item.is_in_group("item"):
		match item.action:
			item.actions.up1: 
				match item.wall:
					item.walls.top:
						move_wall(walls.top, -10)
					item.walls.bottom:
						move_wall(walls.bottom, -10)
			item.actions.down1: 
				match item.wall:
					item.walls.top:
						move_wall(walls.top, 10)
					item.walls.bottom:
						move_wall(walls.bottom, 10)
		item.queue_free()
		
	
func move_wall(node, d):
	node.position.y += d
	
func _physics_process(delta):
	
	if !running: return
	
	var speed = 20.0
	move_wall(walls.top, speed * delta)
	move_wall(walls.bottom, -speed * delta)

	world_move(delta)
	lastBullet += delta
	if $Player.input.fire:
		shoot(delta)
	print(level_height())
	if(!$Player.dead && level_height() < 40):
		$Player.squish()
	if(level_height() <= 0):
		running = false
	
func _input(event):
	if event is InputEventKey:
        if event.pressed and event.scancode == KEY_X:
            move_wall(walls.top, -10)
            move_wall(walls.bottom, 10)
	
var v = Vector2(0,0)
func world_move(delta):
	
	if $Player.input.fire:
		v.x -= rand_range(2, 10)
		v.x = max(-80, v.x)
	else:
		v.x = 100
		
	$Ceiling/Items.translate(-v * delta)
	$Floor/Items.translate(-v * delta)

func squish():
	$Player.dead = true

func level_height():
	return $Floor.global_position.y - $Ceiling.global_position.y 