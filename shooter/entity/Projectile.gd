class_name Projectile extends "Entity.gd"

func create(owner, target, speed):
	position = owner.position
	
	var theta = atan2(target.y - position.y, target.x - position.x)
	velocity.x = cos(theta) * speed
	velocity.y = sin(theta) * speed
