extends ColorRect

# the lower and upper ranges for the spawn
var lx = 0
var ly = 0
var ux = 0
var uy = 0

func _ready():
	EntityManager.register_spawner(self)
	
	visible = false
	lx = rect_global_position.x
	ly = rect_global_position.y
	ux = lx + rect_size.x
	uy = ly + rect_size.y
		
func spawn_one(type, size):
	var x = rand_range(lx + size.x / 2, ux - size.x / 2)
	var y = rand_range(ly + size.y / 2, uy + size.y / 2)
	EntityManager.create_enemy(type, x, y)
