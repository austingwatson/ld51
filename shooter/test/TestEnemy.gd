extends "res://shooter/entity/Enemy.gd"

func _ready():
	projectile_speed = 1000
	projectile_range = 200
	projectile_damage = 2
	
	$AttackRange.get_node("CollisionShape2D").shape.radius = projectile_range / 2
