extends "Mob.gd"

func create(x, y):
	position.x = x
	position.y = y
	speed = 0 # need to force the speed, inspector not working

func process_ai(player):
	target = player.position

func _on_AttackRange_body_entered(body):
	if body.get_class() == "Player":
		use_attack = true

func _on_AttackRange_body_exited(body):
	if body.get_class() == "Player":
		use_attack = false
