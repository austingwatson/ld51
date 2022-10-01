extends Area2D

var x = 0
var y = 0
var width = 0
var height = 0

func _ready():
	x = position.x
	y = position.y
	width = $CollisionShape2D.shape.extents.x * 2
	height = $CollisionShape2D.shape.extents.y * 2
	
func spawn(amount):
	var x = 0
	var y = 0
	for i in amount:
		x = randi() % int(width) + self.x
		y = randi() % int(height) + self.y
		EntityManager.create_enemy(0, x, y)
