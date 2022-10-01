class_name Projectile extends Area2D

var velocity = Vector2.ZERO

func create(owner, target, speed):
	position = owner.position
	
	self.collision_layer = owner.collision_layer
	self.collision_mask = owner.collision_mask
	
	var theta = atan2(target.y - position.y, target.x - position.x)
	velocity.x = cos(theta) * speed
	velocity.y = sin(theta) * speed

func _physics_process(delta):
	position += velocity * delta

func _on_Projectile_body_entered(body):
	if body.get_class() == "Mob":
		body.take_damage(10)
	
	queue_free()
