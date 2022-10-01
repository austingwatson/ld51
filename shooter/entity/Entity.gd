class_name Entity extends KinematicBody2D

# speed that can be changed in the editor
export var speed = 300

# normalized velocity vector to get added to the position
var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity = move_and_slide(velocity)
