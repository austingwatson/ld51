extends ColorRect

func _ready():
	EntityManager.register_spider_boss_spawner(self)
	visible = false

func spawn_boss():
	var position = rect_position + rect_size / 2
	EntityManager.create_enemy("spider-boss", position.x, position.y)
