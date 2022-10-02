extends Area2D

export var spawn_amount = 0

var x = 0
var y = 0
var width = 0
var height = 0

func _ready():
	x = position.x
	y = position.y
	width = $CollisionShape2D.shape.extents.x * 2
	height = $CollisionShape2D.shape.extents.y * 2
	spawn()
	
func spawn():
	var x = 0
	var y = 0
	for i in spawn_amount:
		x = randi() % int(width) + self.x
		y = randi() % int(height) + self.y
		EntityManager.create_enemy(0, x, y)
