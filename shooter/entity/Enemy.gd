class_name Enemy extends "Mob.gd"

# child nodes
onready var sprite = $AnimatedSprite
onready var nav_agent = $NavigationAgent2D
onready var freezeCD = $FreezeCD
var sight_shape: Shape2D

# ai stuff
# current state of the ai
enum STATE {
	IDLE,
	MOVE,
	ATTACK,
	FLEE
}
var state = STATE.IDLE
var player_entered_sight = false # check if the player has entered the sight range
var next_path_find = true # a flag to only path find every 0.5 seconds
var player_entered_attack = false # check if the player has entered the attack range
var just_attacked = false # timer to freeze the enemy after an attack

export var sight_range = 500

func create(x, y):
	position.x = x
	position.y = y
	speed = 100 # need to force the speed, inspector not working

	sight_shape = $SightRange/CollisionShape2D.shape
	sight_shape.radius = sight_range
	$AttackRange/CollisionShape2D.shape.radius = projectile_range

func _physics_process(delta):
	if state == STATE.MOVE || state == STATE.FLEE:
		var move_direction = position.direction_to(nav_agent.get_next_location())
		velocity = move_direction * speed
		if state == STATE.FLEE:
			velocity = -velocity
		nav_agent.set_velocity(velocity)
	else:
		velocity = Vector2.ZERO
	
func _process(delta):
	._process(delta)
	
	if state == STATE.FLEE:
		sprite.flip_v = true
	
func add_sight_range(amount):
		sight_shape.radius += amount
	
func process_ai(player):
	if state != STATE.FLEE:
		if just_attacked:
			state = STATE.IDLE
		else:
			if player_entered_sight:
				state = STATE.MOVE
			if can_use_attack && player_entered_attack:
				state = STATE.ATTACK
	
	if state != STATE.ATTACK:
		use_attack = false
	
	if state == STATE.MOVE || state == STATE.FLEE:
		if next_path_find:
			next_path_find = false
			nav_agent.set_target_location(player.global_position)
		target = player.global_position
	elif state == STATE.ATTACK:
		use_attack = true
		just_attacked = true
		freezeCD.start()

func take_damage(damage):
	.take_damage(damage)
	
	if health > 0 && health <= max_health * 0.25:
		var rng = randi() % 5
		if rng == 0:
			state = STATE.FLEE

func arrived_at_location() -> bool:
	return nav_agent.is_navigation_finished()

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	if !arrived_at_location():
		velocity = move_and_slide(safe_velocity)

func _on_SightRange_body_entered(body):
	if body.get_class() == "Player":
		player_entered_sight = true
		
func _on_SightRange_body_exited(body):
	if body.get_class() == "Player":
		player_entered_sight = false
		
func _on_AttackRange_body_entered(body):
	if body.get_class() == "Player":
		player_entered_attack = true
		
func _on_AttackRange_body_exited(body):
	if body.get_class() == "Player":
		player_entered_attack = false
		
func _on_PathFindTimer_timeout():
	next_path_find = true	
		
func _on_FreezeCD_timeout():
	just_attacked = false
		
func get_class():
	return "Enemy"
