class_name Player extends "Entity.gd"

const movement = [false, false, false, false]

func _ready():
	pass
	
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
