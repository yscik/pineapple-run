extends Node2D

onready var player = $"../Player"
onready var tube = $".."
func _ready():
	
	pass

var bulletScn = preload("res://Bullet.tscn")
var lastBullet = 1

func _physics_process(delta):
	for bullet in get_children():
		bullet.age += delta
		if(bullet.age > 0.9):
			bullet.queue_free()
	
func shoot():
	
	if(lastBullet < 0.08): 
		return

	var direction =  player.aim_direction
	if(direction.x < 0): return

	lastBullet = 0
		
	var bullet = bulletScn.instance()
	bullet.global_position = player.global_position + Vector2(40,35) + Vector2(80,0).rotated(deg2rad(player.aim_angle * 1.4))
	
	bullet.v = direction * 1400
	add_child(bullet)
	bullet.apply_impulse(Vector2(0,0), bullet.v)
	bullet.get_node("Polygon").rotation_degrees = player.aim_angle
	bullet.connect("body_entered", self, "hit", [bullet])
	
	player.get_node("Shoot").play()
	
func hit(item, bullet): 
	bullet.queue_free()
	
	if item.is_in_group("item"):
		item.hitpoints -= 1
		if item.hitpoints <= 0: 
			if(item.action):
				tube.wall_action(item.wall, item.is_good)
			item.destroy()
	
