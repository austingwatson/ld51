class_name Player extends "Mob.gd"

onready var camera = $Camera2D
onready var animtaion = $AnimatedSprite
onready var grenade_timer = $GrenadeTimer
onready var melee_timer = $MeleeTimer
onready var computer_arrow = $ComputerArrow
onready var enemy_arrow = $EnemyArrow
onready var enemy_arrow_timer = $EnemyArrow/Timer
onready var player_hit = $PlayerHit

signal update_health(health)
signal use_computer
signal wave_cd_changed(on_cd)

var movement = [false, false, false, false]
var touching_keypad = false

# grenade properties
var can_use_grenade = true
var use_grenade = false
var grenades = 1

# shield/melee properties
var can_use_melee = true
var use_melee = false

var zoom = false
const min_zoom_level = 0.04
const max_zoom_level = 0.4
const zoom_amount = 0.6

var closest_enemy = Vector2.ZERO

var in_spider_boss_range = false
	
func _ready():
	EntityManager.player = self
	
	self.connect("update_health", EntityManager.shooter_game, "_on_Player_update_health")
	self.connect("use_computer", EntityManager.shooter_game, "player_used_computer")
	self.connect("wave_cd_changed", EntityManager.shooter_game, "wave_cd_changed")

	EntityManager.add_stats_to_player()
	emit_signal("update_health", health)
	
func _input(event):
	if event.is_action_pressed("up"):
		movement[0] = true
	elif event.is_action_pressed("left"):
		movement[1] = true
	elif event.is_action_pressed("down"):
		movement[2] = true
	elif event.is_action_pressed("right"):
		movement[3] = true
	
	elif event.is_action_released("up"):
		movement[0] = false
	elif event.is_action_released("left"):
		movement[1] = false
	elif event.is_action_released("down"):
		movement[2] = false
	elif event.is_action_released("right"):
		movement[3] = false
		
	elif event.is_action_pressed("attack"):
		use_attack = true
	elif event.is_action_released("attack"):
		use_attack = false
		
	elif event.is_action_pressed("activate"):
		if touching_keypad && EntityManager.enemies.size() == 0:
			emit_signal("use_computer")
		elif in_spider_boss_range:
			in_spider_boss_range = false
			EntityManager.remove_spider_boss()
			
	elif event.is_action_released("grenade"):
		use_grenade = true
		
	elif event.is_action_pressed("melee"):
		use_melee = true
	elif event.is_action_released("melee"):
		use_melee = false
	
	elif event.is_action_released("print_enemy"):
		print(EntityManager.find_closest_enemy(get_global_mouse_position()))

func _process(delta):
	velocity = Vector2.ZERO
	if movement[0]:
		velocity.y -= 1
	if movement[1]:
		velocity.x -= 1
	if movement[2]:
		velocity.y += 1
	if movement[3]:
		velocity.x += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animation.play("default")
	else:
		animation.stop()
		
	target = get_global_mouse_position()
	
	if zoom:
		camera.zoom += Vector2(zoom_amount * delta, zoom_amount * delta)
		if camera.zoom >= Vector2(max_zoom_level, max_zoom_level):
			camera.zoom = Vector2(max_zoom_level, max_zoom_level)
			zoom = false
	
	if use_grenade:
		if grenades > 0 && can_use_grenade:
			grenades -= 1
			can_use_grenade = false
			EntityManager.create_projectile(self, bullet_spawn.global_position, target, projectile_speed, projectile_accuracy, projectile_range, projectile_damage, projectile_pierce, projectile_dot_tick, 0.3, projectile_explode_type, false)
			grenade_timer.start()
		use_grenade = false
		
	if use_melee && can_use_melee:
		can_use_melee = false
		EntityManager.create_projectile(self, bullet_spawn.global_position, target, projectile_speed, projectile_accuracy, projectile_range / 5, projectile_damage * 2, 1000, projectile_dot_tick, 0, projectile_explode_type, true)
		melee_timer.start()
		emit_signal("wave_cd_changed", true)
		
	if EntityManager.enemies.size() == 0:
		computer_arrow.visible = true
		computer_arrow.look_at(EntityManager.keypad.position)
		computer_arrow.rotation_degrees += 90.0
	else:
		computer_arrow.visible = false
		
	if enemy_arrow.visible:
		enemy_arrow.look_at(closest_enemy)
		enemy_arrow.rotation_degrees += 90.0

func force_hud_update():
	emit_signal("update_health", health)

func ten_second_timer_timeout():
	var enemy = EntityManager.find_closest_enemy(self.position)
	if enemy != null:
		closest_enemy = enemy.position
		enemy_arrow.visible = true
		enemy_arrow_timer.start()

func take_damage(damage, location):
	if damage >= max_health:
		damage = max_health - 1
	
	.take_damage(damage, location)
	
	if health <= 0:
		SoundManager.play_sound("player-death")
	
	emit_signal("update_health", health)
	player_hit.play()

func _on_Area2D_area_entered(area):
	if area == EntityManager.keypad:
		touching_keypad = true
	
	elif area.is_in_group("SpiderBoss"):
		in_spider_boss_range = true

func _on_Area2D_area_exited(area):
	if area == EntityManager.keypad:
		touching_keypad = false
	elif area.is_in_group("SpiderBoss"):
		in_spider_boss_range = false

func start_zoom():
	camera.current = true
	camera.zoom = Vector2(min_zoom_level, min_zoom_level)
	zoom = true		
		
func _on_GrenadeTimer_timeout():
	can_use_grenade = true

func _on_MeleeTimer_timeout():
	can_use_melee = true
	emit_signal("wave_cd_changed", false)	
	
func _on_Timer_timeout():
	enemy_arrow.visible = false
