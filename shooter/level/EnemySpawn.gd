extends ColorRect

export var spawn_amount = 0

# the lower and upper ranges for the spawn
var lx = 0
var ly = 0
var ux = 0
var uy = 0

func _ready():
	visible = false
	lx = rect_global_position.x
	ly = rect_global_position.y
	ux = lx + rect_size.x
	uy = ly + rect_size.y
	spawn()
	
func spawn():
	var x = lx
	var y = ly
	for i in spawn_amount:
		x = rand_range(lx, ux)
		y = rand_range(ly, uy)
		EntityManager.create_enemy(0, x, y)
