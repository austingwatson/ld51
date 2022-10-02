class_name Projectile extends Area2D

var velocity = Vector2.ZERO
var start_position = Vector2.ZERO
var distance = Vector2.ZERO
var damage = 0
var pierce = 0
var hit_targets = []

func create(owner, target, speed, distance, damage, pierce):
	position = owner.position
	start_position = position
	
	self.collision_layer = owner.collision_layer
	self.collision_mask = owner.collision_mask
	
	var theta = atan2(target.y - position.y, target.x - position.x)
	velocity.x = cos(theta) * speed
	velocity.y = sin(theta) * speed
	
	self.distance = distance
	self.damage = damage
	self.pierce = pierce
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
		body.take_damage(damage)
		damage = 0
	
	queue_free()
