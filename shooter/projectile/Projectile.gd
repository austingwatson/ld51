class_name Projectile extends Area2D

var velocity = Vector2.ZERO
var start_position = Vector2.ZERO
var distance = Vector2.ZERO
var damage = 0
var pierce = 0
var dot = 0
var hit_targets = []

func create(owner, target, speed, accuracy, distance, damage, pierce, dot):
	position = owner.position
	start_position = position
	
	self.collision_layer = owner.collision_layer
	self.collision_mask = owner.collision_mask
	
	# find the direction the bullet should shoot
	# add some randomoness if necessary
	var theta = atan2(target.y - position.y, target.x - position.x)
	theta = rad2deg(theta)
	var rng = 360 - (360 * accuracy)
	var inaccuracy = randf() * rng - (rng * 0.5)
	theta += inaccuracy
	theta = deg2rad(theta)
	
	velocity.x = cos(theta) * speed
	velocity.y = sin(theta) * speed
	
	self.distance = distance
	self.damage = damage
	self.pierce = pierce
	self.dot = dot
	hit_targets.clear()

func _physics_process(delta):
	position += velocity * delta
	
func _process(delta):
	if position.distance_to(start_position) >= distance:
		queue_free()

func _on_Projectile_body_entered(body):
	# checks if the body that enters is a mob type class
	# in godot 4 can use a more oop way to do it
	
	if body.get_class() == "Mob" || body.get_class() == "Enemy" || body.get_class() == "Player":
		for hit in hit_targets:
			print(hit, ", ", body)
			if hit == body:
				return
		
		body.take_damage(damage)
		if dot > 0:
			body.add_dot(dot)
		
		if pierce > 1:
			hit_targets.append(body)
			pierce -= 1
		else:
			damage = 0
			queue_free()
	else:
		queue_free()
