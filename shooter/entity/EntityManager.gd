extends Node

# preload all needed entity scenes
const projectile_scene = preload("res://shooter/projectile/Projectile.tscn")
const explosion_scene = preload("res://shooter/projectile/Explosion.tscn")
const test_enemy_scene = preload("res://shooter/test/TestEnemy.tscn")
const turret_scene = preload("res://shooter/entity/Turret.tscn")
const soldier_scene = preload("res://shooter/entity/Soldier.tscn")
const general_scene = preload("res://shooter/entity/General.tscn")
const chem_thrower_scene = preload("res://shooter/entity/ChemThrower.tscn")
const drone_scene = preload("res://shooter/entity/Drone.tscn")

# keep track of the scene that things should be added to
var shooter_game: Node

# needed to track which nodes to buff every ten seconds
var difficulty_modifier = 1
var enemies = []
var player = null
var keypad = null

# the enemy spawners of the level
var spawners = []
var turret_spawners = []

# current buffs that the enemies have
# stored in an int array
var buffs = []
const health = 1
const speed = 25
const damage = 1
const amount = 1
const dot = 1
const proj_range = 25
const attack_speed = 0.05

# current buffs for the player
var player_health = 0
var player_grenades = 0
var player_speed = 0
var player_damage = 0
var player_amount = 0
var player_dot = 0
var player_range = 0
var player_attack_speed = 0

var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()

# restarts a level, removing some buffs
func new_level(remove_amount):
	difficulty_modifier += 1
	spawners.clear()
	turret_spawners.clear()
	
	var lower = buffs.size() - 1 - remove_amount
	if lower <= 0:
		lower = 0
	for i in range(buffs.size() - 1, lower, -1):
		buffs.remove(i)

# this function might cause the game to crass
# will have to try and see if it is overloading
# queue free
func kill_all_enemies():
	for enemy in enemies:
		enemy.queue_free()
	enemies.clear()

func find_closest_enemy(position):
	var distance = 1000000.0
	var closest = null
	
	for enemy in enemies:
		var dist = enemy.position.distance_to(position)
		if dist < distance:
			distance = dist
			closest = enemy
	return closest

func spawn_full_enemies():
	# amount of enemies to spawn
	var enemy_amount = 0
	
	if spawners.size() > 0:
		# drone amount
		enemy_amount = get_roomba_amount(difficulty_modifier)
		for i in range(1, enemy_amount):
			var spawner = spawners[randi() % spawners.size()]
			spawner.spawn_one("roomba")
		
		# soldiers
		enemy_amount = get_soldier_amount(difficulty_modifier)
		for i in range(1, enemy_amount):
			var spawner = spawners[randi() % spawners.size()]
			spawner.spawn_one("soldier")
		
		# generals
		enemy_amount = get_general_amount(difficulty_modifier)
		for i in range(1, enemy_amount):
			var spawner = spawners[randi() % spawners.size()]
			spawner.spawn_one("general")
			
		# chem throwers
		enemy_amount = get_chem_thrower_amount(difficulty_modifier)
		for i in range(1, enemy_amount):
			var spawner = spawners[randi() % spawners.size()]
			spawner.spawn_one("chem-thrower")
		
	# turret amount
	if turret_spawners.size() > 0:
		enemy_amount = get_turret_amount(difficulty_modifier)
		for i in range(1, enemy_amount):
			var turret_spawner = turret_spawners[randi() % turret_spawners.size()]
			turret_spawner.spawn_one()

func add_single_stat_to_player(stat):
	match stat:
		"health":
			player_health += health
		"speed":
			player_speed += speed
		"damage":
			player_damage += damage
		"amount":
			player_amount += amount
		"dot":
			player_dot += dot
		"range":
			#player_range += proj_range
			pass
		"grenade":
			player_grenades += 1
		"debuff":
			print("debuff")
		"attack-speed":
			player_attack_speed += attack_speed

# adds the stats to the player
func add_stats_to_player():
	player.max_health += player_health
	player.health += player_health
	player.grenades += player_grenades
	player.speed += player_speed
	player.projectile_damage += player_damage
	player.projectile_amount += player_amount
	player.projectile_dot_tick += player_dot
	#player.projectile_range += player_range
	player.projectile_attack_speed += player_attack_speed
	player.change_attack_speed()

# adds the entity to the main node
# so it shows up on screen
func add_node_to_root(node):
	shooter_game.add_child(node)

func add_enemy(enemy):
	enemies.append(enemy)
	
	#for buff in buffs:
		#add_buff_to_enemy(enemy, buff)
	
	add_node_to_root(enemy)

func create_multi_enemy(type, x, y, amount):
	for i in amount:
		create_enemy(type, x, y)

func create_enemy(type, x, y):
	var enemy = null
	
	match type:
		"random":
			var rng = randi() % 4
			match rng:
				0:
					create_enemy("roomba", x, y)
				1:
					create_enemy("soldier", x, y)
				2:
					create_enemy("general", x, y)
				3:
					create_enemy("chem-thrower", x, y)
		"turret":
			enemy = turret_scene.instance()
			enemy.create(x, y)
		"test-enemy":
			enemy = test_enemy_scene.instance()
			enemy.create(x, y)
		"roomba":
			enemy = drone_scene.instance()
			enemy.create(x, y)
		"soldier":
			enemy = soldier_scene.instance()
			enemy.create(x, y)
		"general":
			enemy = general_scene.instance()
			enemy.create(x, y)
		"chem_thrower":
			enemy = chem_thrower_scene.instance()
			enemy.create(x, y)
		
	if enemy != null:
		add_enemy(enemy)

func create_projectile(owner, target, speed, accuracy, distance, damage, pierce, dot, explode, explode_type, shielding):
	var projectile = projectile_scene.instance()
	projectile.create(owner, target, speed, accuracy, distance, damage, pierce, dot, explode, explode_type, shielding)
	add_node_to_root(projectile)
	
func create_explosion(owner, damage, timer, dot, type):
	var explosion = explosion_scene.instance()
	explosion.create(owner, damage, timer, dot, type)
	add_node_to_root(explosion)

func register_spawner(spawner):
	spawners.append(spawner)	
	
func register_turret_spawner(spawner):
	turret_spawners.append(spawner)
	
func add_buff_to_enemies(buff):
	pass
	if buff != "spawn":
		buffs.append(buff)
	else:
		var enemy = enemies[randi() % enemies.size()]
		create_enemy("random", enemy.position.x + 10, enemy.position.y)

	for enemy in enemies:
		add_buff_to_enemy(enemy, buff)
	
func add_buff_to_enemy(enemy, buff):
	match buff:
		"health":
			enemy.max_health += health
			enemy.health += health
		"speed":
			enemy.speed += speed
		"damage":
			enemy.projectile_damage += damage
		"amount":
			enemy.projectile_amount += amount
		"dot":
			enemy.projectile_dot_tick += dot
		"range":
			#enemy.projectile_range += proj_range
			#if enemy.get_class() == "Enemy":
			#	enemy.add_sight_range(proj_range)
			pass
		"attack-speed":
			enemy.projectile_attack_speed -= attack_speed
			enemy.change_attack_speed()
	
func process_enemies():
	for enemy in enemies:
		enemy.process_ai(player)
	
# iterates through the enemy array
# if they are !alive
# then removes them from the scene and array
func remove_dead_enemies():
	for i in range(enemies.size() - 1, -1, -1):
		if !enemies[i].alive:
			enemies[i].queue_free()
			enemies.remove(i)
		
# math functions to find how many enemies to spawn
func get_roomba_amount(x):
	var lb = x
	var ub = x + 2
	return random.randi_range(lb, ub)
	
func get_turret_amount(x):
	var lb = x
	var ub = x
	return random.randi_range(lb, ub)
	
func get_soldier_amount(x):
	var lb = x - 2
	var ub = x - 1
	return random.randi_range(lb, ub)
	
func get_general_amount(x):
	var lb = x - 4
	var ub = x - 2
	return random.randi_range(lb, ub)
	
func get_chem_thrower_amount(x):
	var lb = x - 6
	var ub = x - 4
	return random.randi_range(lb, ub)
