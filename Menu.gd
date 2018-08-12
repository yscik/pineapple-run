extends CanvasLayer


func _ready():
	if !Global.started:
		pause()
	set_process_input(true)
	pass

func _input(event):
	if event is InputEventKey && event.pressed && event.scancode == KEY_ESCAPE:
		pause()
	

var paused = false

func pause():
	paused = !get_tree().paused
	get_tree().paused = paused
	$Menu.visible = paused
	
	if(Global.started):
		$Menu/Screens/Paused.visible = paused
		$Menu/Screens/Start.visible = false
	else:
		$Menu/Screens/Start.visible = paused
		$Menu/Screens/Paused.visible = false
		Global.started = true
	
	$"../Music".playing = !paused
	
func gameover():
	$Menu.visible = true
	$Menu/Screens/Dead.visible = true

func restart():
	$Menu.visible = false
	$Menu/Screens/Dead.visible = false
	get_tree().reload_current_scene()
	get_tree().paused = false
	Global.started = true

func quit():
	get_tree().quit()