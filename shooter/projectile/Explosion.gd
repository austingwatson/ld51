extends Area2D

var damage = 0
var dot = 0
var hit_targets = []

func create(owner, damage, timer, dot, type):
	position = owner.position
	
	self.collision_layer = owner.collision_layer
	self.collision_mask = owner.collision_mask
	
	self.damage = damage
	$Timer.wait_time = timer
	self.dot = dot
	
	if type == 0:
		$Animation.play("shock")
	elif type == 1:
		$Animation.play("slime")
	else:
		$Animation.play("explosion")
	

func _on_Grenade_body_entered(body):
	if body.get_class() == "Mob" || body.get_class() == "Player" || body.get_class() == "Enemy":
		var already_hit = false
		
		for hit in hit_targets:
			if hit == body:
				already_hit = true
				
		if !already_hit:
			body.take_damage(damage)
			
		if dot > 0:
			body.add_dot(dot)

func _on_Timer_timeout():
	queue_free()
