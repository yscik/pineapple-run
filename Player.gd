extends KinematicBody2D

var animator
var character
var enabled = true
var dead = false
export var shooting = false

var v = Vector2()
var GRAVITY = Vector2(0, -10)
var flipped = false

var input = {
	up = false,
	fire = false
}
var keyMap = {
	up = [KEY_UP, KEY_W],
	fire = BUTTON_LEFT
}


func update_input():
	set_input("up", keyMap.up)
		
	input.fire = Input.is_mouse_button_pressed(keyMap.fire)

func set_input(skill, keys):
	input[skill] = (Input.is_key_pressed(keys[0]) || Input.is_key_pressed(keys[1]))
	
func _physics_process(delta):
	
	if !enabled || dead: return
	
	update_input()
	
	platform_movement()		


func platform_movement():
	
	if input.up:
		if is_on_floor():
			v.y = -400
	
	if !is_on_floor():
		v.y -= GRAVITY.y
	
	move_and_slide(v, GRAVITY)

func platform_anim():
	
	var anim = "Idle"
	
	if v.x < -1 && !flipped || v.x > 1 && flipped:
		flipped = !flipped
		flip()
	
	if(v.x != 0):
		anim = "Walk"
	if(v.y < 0):
		anim = "Jump"
	if(!is_on_floor() && v.y > GRAVITY.y):
		anim = "Fall"
	
	animator.play(anim)
	
func platform_exit():
	if flipped:
		flip()
	
	flipped = false

func flip():
	character.apply_scale(Vector2(-1, 1))
	
func speed(direction, accel):
	v[direction] = min(300, abs(v[direction]) + 10) * accel
	
func squish():
	print("wtf!")
	dead = true
	$Animation.play("Dead")
