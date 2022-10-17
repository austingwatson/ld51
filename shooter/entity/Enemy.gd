class_name Enemy extends "Mob.gd"

# child nodes
onready var sprite = $AnimatedSprite
onready var nav_agent = $NavigationAgent2D
onready var freezeCD = $FreezeCD

# ai stuff
# current state of the ai
enum STATE {
	IDLE,
	MOVE,
	ATTACK,
	FLEE
}
var state = STATE.IDLE
var next_path_find = true # a flag to only path find every 0.5 seconds
var just_attacked = false # timer to freeze the enemy after an attack

export var sight_range = 500
export(String, "roomba", "soldier", "general", "chem-thrower", "other") var enemy_name := "roomba"

func _ready():
	$SightRangeDebug/CollisionShape2D.shape.radius = sight_range
	$AttackRangeDebug/CollisionShape2D.shape.radius = projectile_range

func create(x, y):
	position.x = x
	position.y = y

func _physics_process(delta):
	if state == STATE.MOVE || state == STATE.FLEE:
		var move_direction = position.direction_to(nav_agent.get_next_location())
		velocity = move_direction * speed
		if state == STATE.FLEE:
			velocity = -velocity
		nav_agent.set_velocity(velocity)
	
	velocity = Vector2.ZERO
	
func _process(delta):
	if state == STATE.FLEE:
		sprite.flip_v = true
	
func add_sight_range(amount):
	sight_range += amount
	
func process_ai(player):
	if state != STATE.FLEE:
		if just_attacked:
			state = STATE.IDLE
		else:
			if can_use_attack && player_in_attack(player.position):
				state = STATE.ATTACK
			elif player_in_sight(player.position):
				state = STATE.MOVE
	
	if state != STATE.ATTACK:
		use_attack = false
	
	if state == STATE.MOVE || state == STATE.FLEE:
		if next_path_find:
			next_path_find = false
			nav_agent.set_target_location(player.position)
		target = player.global_position
	elif state == STATE.ATTACK:
		target = player.global_position
		use_attack = true
		just_attacked = true
		freezeCD.start()

func player_in_sight(position: Vector2) -> bool:
	return self.position.distance_to(position) <= sight_range

func player_in_attack(position: Vector2) -> bool:
	return self.position.distance_to(position) <= projectile_range

func take_damage(damage, location):
	.take_damage(damage, location)
	
	if health > 0 && health <= max_health * 0.25:
		var rng = randi() % 5
		if rng == 0:
			state = STATE.FLEE

func arrived_at_location() -> bool:
	return nav_agent.is_navigation_finished()

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	if !arrived_at_location():
		if safe_velocity.length() > 0:
			sprite.play("default")
		else:
			sprite.stop()
		velocity = move_and_slide(safe_velocity)
		
func _on_PathFindTimer_timeout():
	next_path_find = true	
		
func _on_FreezeCD_timeout():
	just_attacked = false
