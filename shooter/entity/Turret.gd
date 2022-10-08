extends "Mob.gd"

export var attack_range = 100

const enemy_name = "turret"

func create(x, y):
	position.x = x
	position.y = y
	speed = 0 # need to force the speed, inspector not working

func process_ai(player):
	target = player.position
	
	if player_in_attack(player.position):
		use_attack = true

func player_in_attack(position: Vector2) -> bool:
	return self.position.distance_to(position) <= attack_range
