extends Node

var started

func _ready():
		
	if OS.has_feature("web"):
		OS.window_maximized = true
		