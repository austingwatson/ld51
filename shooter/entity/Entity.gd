class_name Entity extends KinematicBody2D

export var speed = 300

var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta
