extends Area2D

var animation: AnimatedSprite

var damage = 0
var dot = 0
var loops = 1
var current_loop = 0
var animation_restarted = false

var mobs_hit = []

func create(owner, damage, dot, type, loops):
	self.collision_layer = owner.collision_layer
	self.collision_mask = owner.collision_mask
	
	self.damage = damage
	self.dot = dot
	self.loops = loops
	
	animation = get_node("Animation")
	if type == 0:
		animation.play("shock")
	elif type == 1:
		animation.play("slime")
	else:
		animation.play("explosion")
		
	var current_animation = animation.animation
	position = owner.position + animation.frames.get_frame(current_animation, 0).get_size() / 2
		
	SoundManager.play_sound("player-grenade-explosion")

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
		for mob_hit in mobs_hit:
			if body == mob_hit:
				return
	
		mobs_hit.append(body)
		body.take_damage(damage, null)
		if dot > 0:
			body.add_dot(dot)
