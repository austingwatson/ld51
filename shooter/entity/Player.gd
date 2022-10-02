class_name Player extends "Mob.gd"

onready var camera = $Camera2D

signal update_health(health)
signal use_computer

const movement = [false, false, false, false]
var touching_keypad = false
var zoom = false
	
func _ready():
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
		camera.zoom += Vector2(0.01, 0.01)
		if camera.zoom >= Vector2(1, 1):
			camera.zoom = Vector2(1, 1)
			zoom = false

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
	camera.zoom = Vector2(0.1, 0.1)
	zoom = true		
		
func get_class():
	return "Player"
