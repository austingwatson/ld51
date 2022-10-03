class_name Projectile extends Area2D

var velocity = Vector2.ZERO
var start_position = Vector2.ZERO
var distance = Vector2.ZERO
var damage = 0
var pierce = 0
var dot = 0
var explode = 0
var explode_type = 0
var shielding = false
var hit_targets = []

# temp value to see what explosion sound sh

func create(owner, target, speed, accuracy, distance, damage, pierce, dot, explode, explode_type, shielding):
	position = owner.position
	start_position = position
	
	look_at(target)
	rotation_degrees += 90.0
	
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
	self.explode = explode
	self.explode_type = explode_type
	self.shielding = shielding
	
	if shielding:
		$Sprite.play("shield")
		scale = Vector2(4, 4)
	elif owner.get_class() == "Player":
		if explode > 0:
			$Sprite.play("shock")
			scale = Vector2(3, 3)
		else:
			$Sprite.play("player_bullet")
			scale = Vector2(1, 1)
	elif owner.get_class() == "ChemThrower":
		$Sprite.play("slime")
		scale = Vector2(3, 3)
	elif owner.get_class() == "Drone":
		$Sprite.play("close_shock")
		scale = Vector2(4, 4)
	else:
		$Sprite.play("default")
		scale = Vector2(1, 1)
	$Sprite.frame = 0
	hit_targets.clear()
	
	# what sound to play
	if owner.get_class() == "Player":
		if explode > 0:
			SoundManager.play_sound("player-grenade")
		elif shielding:
			SoundManager.play_sound("player-melee")
		else:
			SoundManager.play_sound("player-shot")
	elif owner.get_class() == "Drone":
		SoundManager.play_sound("drone-shot")
	elif owner.get_class() == "ChemThrower":
		SoundManager.play_sound("chem-thrower-shot")
	else:
		SoundManager.play_sound("soldier-shot")

func _physics_process(delta):
	position += velocity * delta
	
func _process(delta):
	if position.distance_to(start_position) >= distance:
		if explode > 0:
			EntityManager.create_explosion(self, damage, explode, dot, explode_type)
		queue_free()

func _on_Projectile_body_entered(body):	
	# checks if the body that enters is a mob type class
	# in godot 4 can use a more oop way to do it
	# awful way to do this!!
	if body.get_class() == "Mob" || body.get_class() == "Enemy" || body.get_class() == "Player" || body.get_class() == "Drone" || body.get_class() == "ChemThrower" || body.get_class() == "Soldier":
		for hit in hit_targets:
			if hit == body:
				return
		
		body.take_damage(damage)
		if dot > 0:
			body.add_dot(dot)
		
		if pierce > 1:
			hit_targets.append(body)
			pierce -= 1
		else:
			if explode > 0:
				EntityManager.create_explosion(self, damage, explode, dot, explode_type)
			damage = 0
			queue_free()
	elif !shielding:
		if explode:
			EntityManager.create_explosion(self, damage, explode, dot, explode_type)
		damage = 0
		queue_free()

func _on_Projectile_area_entered(area):
	if shielding && area.get_class() == "Projectile":
		area.queue_free()
	if area.get_class() == "Crate":
		if pierce > 1:
			pierce -= 1
		else:
			queue_free()

func get_class():
	return "Projectile"
