tool
extends StaticBody2D

enum actions {none, up1, down1}
enum walls {top, bottom, middle}
	
export (actions) var action
export (walls) var wall

func _ready():
	update()
	
func _process(delta):
	update()

func update():
	$Action.visible = action != actions.none
	if action == actions.up1:
		$Action.rect_rotation = 180
	else:
		$Action.rect_rotation = 0
	
