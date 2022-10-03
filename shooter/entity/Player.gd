class_name Player extends "Mob.gd"

onready var camera = $Camera2D
onready var animtaion = $AnimatedSprite
onready var grenade_timer = $GrenadeTimer
onready var melee_timer = $MeleeTimer
onready var computer_arrow = $ComputerArrow
onready var enemy_arrow = $EnemyArrow
onready var enemy_arrow_timer = $EnemyArrow/Timer

signal update_health(health)
signal use_computer

const movement = [false, false, false, false]
var touching_keypad = false

# grenade properties
var can_use_grenade = true
var use_grenade = false
var grenades = 2

# shield/melee properties
var can_use_melee = true
var use_melee = false

var zoom = false
const min_zoom_level = 0.04
const max_zoom_level = 0.4
const zoom_amount = 0.004
	
func _ready():
	._ready()
	EntityManager.player = self
	
	var root = get_tree().root
	var current_scene = root.get_child(root.get_child_count() - 1)
	self.connect("update_health", current_scene, "_on_Player_update_health")
	self.connect("use_computer", current_scene, "player_used_computer")
	
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
			
	elif event.is_action_released("grenade"):
		use_grenade = true
		
	elif event.is_action_pressed("melee"):
		use_melee = true
	elif event.is_action_released("melee"):
		use_melee = false

func _process(delta):
	._process(delta)
	
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
		
	target = get_global_mouse_position()
	
	if zoom:
		camera.zoom += Vector2(zoom_amount, zoom_amount)
		if camera.zoom >= Vector2(max_zoom_level, max_zoom_level):
			camera.zoom = Vector2(max_zoom_level, max_zoom_level)
			zoom = false
	
	if use_grenade:
		if grenades > 0 && can_use_grenade:
			grenades -= 1
			can_use_grenade = false
			EntityManager.create_projectile(self, target, projectile_speed, projectile_accuracy, projectile_range, projectile_damage, projectile_pierce, projectile_dot_tick, 0.3, projectile_explode_type, false)
			grenade_timer.start()
		use_grenade = false
		
	if use_melee && can_use_melee:
		can_use_melee = false
		EntityManager.create_projectile(self, target, projectile_speed, projectile_accuracy, projectile_range / 5, projectile_damage * 2, projectile_pierce * 2, projectile_dot_tick, 0, projectile_explode_type, true)
		melee_timer.start()

func ten_second_timer_timeout():
	var enemy = EntityManager.find_closest_enemy(self.position)
	if enemy != null:
		print(enemy)

func take_damage(damage):
	.take_damage(damage)
	emit_signal("update_health", health)

func _on_Area2D_area_entered(area):
	if area.get_class() == "Keypad":
		touching_keypad = true

func _on_Area2D_area_exited(area):
	if area.get_class() == "Keypad":
		touching_keypad = false

func start_zoom():
	camera.current = true
	camera.zoom = Vector2(min_zoom_level, min_zoom_level)
	zoom = true		
		
func _on_GrenadeTimer_timeout():
	can_use_grenade = true

func _on_MeleeTimer_timeout():
	can_use_melee = true		
		
func get_class():
	return "Player"
