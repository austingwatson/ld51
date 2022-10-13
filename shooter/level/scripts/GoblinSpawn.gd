extends ColorRect

const goblin_scene = preload("res://shooter/entity/Goblin.tscn")

func _ready():
	EntityManager.register_goblin(self)
	visible = false

func spawn_goblin():
	var goblin = goblin_scene.instance()
	goblin.position = rect_position + rect_size / 2
	return goblin
