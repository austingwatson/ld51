extends Area2D

var animation: AnimatedSprite

var damage = 0
var dot = 0
var initial_damage = true

func create(owner, damage, timer, dot, type):
	position = owner.position
	
	self.collision_layer = owner.collision_layer
	self.collision_mask = owner.collision_mask
	
	self.damage = damage * 2
	self.dot = dot
	
	animation = get_node("Animation")
	if type == 0:
		animation.play("shock")
	elif type == 1:
		animation.play("slime")
	else:
		animation.play("explosion")
		
	SoundManager.play_sound("player-grenade-explosion")

func _process(delta):
	if animation.frame > 0:
		initial_damage = false
	if animation.frame == 3:
		queue_free()

func _on_Grenade_body_entered(body):
	if body.get_class() == "Mob" || body.get_class() == "Player" || body.get_class() == "Enemy" || body.get_class() == "Drone" || body.get_class() == "ChemThrower":
		if initial_damage:
			body.take_damage(damage)
			
		if dot > 0:
			body.add_dot(dot)
