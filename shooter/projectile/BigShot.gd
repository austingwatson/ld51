extends "Projectile.gd"

const start_size = Vector2(0.1, 0.1)
const max_size = Vector2(12, 12)
const added_size = Vector2(0.1, 0.1)
const speed = 200

var target
var send_shot = false

func create(owner, target, speed, accuracy, distance, damage, pierce, dot, explode, explode_type, shielding):
	.create(owner, target, speed, accuracy, distance, damage, pierce, dot, explode, explode_type, shielding)
	
	self.target = target
	scale = start_size

func offset_big_shot():
	var theta = atan2(target.y - position.y, target.x - position.x)
	position.x += cos(theta) * 40
	position.y += sin(theta) * 40
	
func _process(delta):
	if !send_shot:
		scale += added_size
		
		if scale >= max_size:
			send_shot = true
		
			var theta = atan2(target.y - position.y, target.x - position.x)
			velocity.x = cos(theta) * speed
			velocity.y = sin(theta) * speed
