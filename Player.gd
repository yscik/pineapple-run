extends KinematicBody2D

var animator
var character
var enabled = true
var dead = false
export var shooting = false

var v = Vector2()
var GRAVITY = Vector2(0, -20)
var flipped = false

var input = {
	up = false,
	fire = false
}
var keyMap = {
	up = [KEY_UP, KEY_W],
	fire = BUTTON_LEFT
}

func _ready():
	animator = $Visual


func update_input():
	set_input("up", keyMap.up)
		
	input.fire = Input.is_mouse_button_pressed(keyMap.fire)

func set_input(skill, keys):
	input[skill] = (Input.is_key_pressed(keys[0]) || Input.is_key_pressed(keys[1]))
	
func _physics_process(delta):
	
	if !enabled || dead: return
	
	update_input()
	aim(delta)
	
	platform_movement()		
	platform_anim()

var aim_direction
var aim_angle
func aim(delta):
	
	var mousePos = get_global_mouse_position()
	var direction = (mousePos - global_position).normalized()
	aim_angle = -rad2deg(direction.angle_to(Vector2(1,0)))
	aim_angle = min(25, max(-45, aim_angle))
	aim_direction = Vector2(1,0).rotated(deg2rad(aim_angle))
	
	$Gun.rotation_degrees = aim_angle

func platform_movement():
	
	if input.up:
		if is_on_floor():
			v.y = -600
	
	if !is_on_floor():
		v.y -= GRAVITY.y
	
	v.x = 600
	
	move_and_slide(v, GRAVITY)

var anim
func platform_anim():
	
	var current = anim
	
	var anim = "stand"
	
	if(is_on_floor() && !is_on_wall()):
		anim = "run"
	else:
		anim = "stand"
	
	if anim != current:
		animator.play(anim)
		
	$Gun/Fire.visible = input.fire

#func speed(direction, accel):
#	v[direction] = min(300, abs(v[direction]) + 10) * accel
	
func squish():
	dead = true
	$Animation.play("Dead")
