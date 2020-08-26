extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var Ship:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Ship=find_parent('World').find_node('Ship')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var dist = abs(Ship.position.distance_to(position))
#
#	position = position.move_toward(Ship.position, dist*0.75)
