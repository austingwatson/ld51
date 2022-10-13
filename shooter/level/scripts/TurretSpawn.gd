extends ColorRect

# the lower and upper ranges for the spawn
var lx = 0
var ly = 0
var ux = 0
var uy = 0

export var max_turrets = 0
var current_turrets = 0

func _ready():
	EntityManager.register_turret_spawner(self)
	
	visible = false
	lx = rect_global_position.x
	ly = rect_global_position.y
	ux = lx + rect_size.x
	uy = ly + rect_size.y
		
func spawn_one():
	if current_turrets >= max_turrets:
		return
	EntityManager.create_enemy("turret", rand_range(lx, ux), rand_range(ly, uy))
	current_turrets += 1
