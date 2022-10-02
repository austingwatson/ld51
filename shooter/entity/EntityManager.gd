extends Node

# preload all needed entity scenes
const projectile_scene = preload("res://shooter/projectile/Projectile.tscn")
const test_enemy_scene = preload("res://shooter/test/TestEnemy.tscn")
const turret_scene = preload("res://shooter/entity/Turret.tscn")

# needed to track which nodes to buff every ten seconds
var difficulty_modifier = 0
var enemies = []
var player = null

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

# functions to decide how many enemies, and of what type
# to spawn

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

func spawn_full_enemies():
	for spawner in spawners:
		spawner.spawn_one("test-enemy")
	for turret_spawner in turret_spawners:
		turret_spawner.spawn_one()

# adds the entity to the main node
# so it shows up on screen
func add_node_to_root(node):
	var root = get_tree().root
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.add_child(node)

func add_enemy(enemy):
	enemies.append(enemy)
	
	for buff in buffs:
		add_buff_to_enemy(enemy, buff)
	
	var root = get_tree().root
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.call_deferred("add_child", enemy)

func create_enemy(type, x, y):
	var enemy = null
	
	match type:
		"turret":
			enemy = turret_scene.instance()
			enemy.create(x, y)
		"test-enemy":
			enemy = test_enemy_scene.instance()
			enemy.create(x, y)
		
	if enemy != null:
		add_enemy(enemy)

func create_projectile(owner, target, speed, accuracy, distance, damage, pierce, dot):
	var projectile = projectile_scene.instance()
	projectile.create(owner, target, speed, accuracy, distance, damage, pierce, dot)
	add_node_to_root(projectile)

func register_spawner(spawner):
	spawners.append(spawner)	
	
func register_turret_spawner(spawner):
	turret_spawners.append(spawner)
	
func add_buff_to_enemies(buff):
	if buff != "spawn":
		buffs.append(buff)
	else:
		if spawners.size() > 0:
			var rng = randi() % spawners.size()
			spawners[rng].spawn_one("test-enemy")
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
	
func process_enemies():
	for enemy in enemies:
		enemy.process_ai(player)
	
# iterates through the enemy array
# if they are !alive
# then removes them from the scene and array
func remove_dead_enemies():
	var i = 0
	while i < enemies.size():
		if !enemies[i].alive:
			enemies[i].queue_free()
			enemies.remove(i)
			i -= 1
		i += 1
