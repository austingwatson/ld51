extends Area2D

var animation: AnimatedSprite

var damage = 0
var dot = 0
var initial_damage = true
var loops = 1
var current_loop = 0
var animation_restarted = false

func create(owner, damage, dot, type, loops):
	position = owner.position
	
	self.collision_layer = owner.collision_layer
	self.collision_mask = owner.collision_mask
	
	self.damage = damage * 2
	self.dot = dot
	self.loops = loops
	
	animation = get_node("Animation")
	if type == 0:
		animation.play("shock")
	elif type == 1:
		animation.play("slime")
	else:
		animation.play("explosion")
		
	SoundManager.play_sound("player-grenade-explosion")

func _physics_process(delta):
	initial_damage = false

func _process(delta):
	if animation.frame == 0:
		animation_restarted = true
	if animation_restarted && animation.frame == 3:
		animation_restarted = false
		current_loop += 1
	if current_loop == loops:
		queue_free()

func _on_Grenade_body_entered(body):
	if body.is_in_group("Mob"):
		if initial_damage:
			body.take_damage(damage, global_position)
			
		if dot > 0:
			body.add_dot(dot)
