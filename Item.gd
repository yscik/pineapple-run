
extends StaticBody2D

#enum actions {none, up1, down1}
#enum walls {top, bottom, middle}
	
var hitpoints = 0
var offset
export(String) var action = ""
export(String) var wall = "bottom"
var is_good

func _ready():
	update()
#
#var colors = {
#	good = Color("#4951f8"),
#	bad = Color("#e82142"),
#	normal = Color("#000000"),
#}	

var colors = {
	good = Color("#386eed"),
	bad = Color("#e20f3b"),
	normal = Color("#090909"),
}	

func update():
	
	modulate = colors["normal" if !action else "good" if is_good else "bad"]
	
	$Box.rotation_degrees = 180 if wall == "top" else 0
	$Box.frame = 2 if !action else 1 if is_good else 0
		
	
func destroy():
	set_collision_layer_bit(3, false)
	$Box.visible = false
	
	$Explode.visible = true
	$Explode.play()
	$Destroy.play()
	if action:
		if is_good: 
			$Good.play()
		else:
			$Bad.play()
	$Tween.interpolate_callback(self, 1, "queue_free")
	$Tween.start()