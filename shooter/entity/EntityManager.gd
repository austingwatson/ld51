extends Node

# preload all needed entity scenes
const projectile_scene = preload("res://shooter/entity/projectile/Projectile.tscn")

func create_projectile(owner, target, speed):
	var projectile = projectile_scene.instance()
	projectile.create(owner, target, speed)
	
	var root = get_tree().root
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.add_child(projectile)
