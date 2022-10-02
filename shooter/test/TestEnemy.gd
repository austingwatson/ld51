extends "res://shooter/entity/Enemy.gd"

func _ready():
	$AttackRange.get_node("CollisionShape2D").shape.radius = projectile_range / 2
