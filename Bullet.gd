extends RigidBody2D

var age = 0.0
export var v = Vector2(0,0)
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	$Sprite.frame = randi() % 5
	#rotation_degrees = randi() % 360
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
