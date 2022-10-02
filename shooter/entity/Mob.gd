class_name Mob extends KinematicBody2D

# child nodes
onready var attack = $AttackCD

export var max_health = 1
var health = max_health
var alive = true

export var speed = 300
var velocity = Vector2.ZERO

var target = Vector2.ZERO
var can_use_attack = true
var use_attack = false
export var projectile_speed = 1000
export var projectile_range = 400
export var projectile_damage = 1
export var projectile_pierce = 1
export var projectile_amount = 3
export var projectile_accuracy = 1.0

func _physics_process(delta):
	velocity = move_and_slide(velocity)

func _process(delta):
	if use_attack and can_use_attack:
		can_use_attack = false
		EntityManager.create_projectile(self, target, projectile_speed, projectile_accuracy, projectile_range, projectile_damage, projectile_pierce)
		
		for i in range(1, projectile_amount):
			EntityManager.create_projectile(self, target, projectile_speed, projectile_accuracy - 0.1, projectile_range, projectile_damage, projectile_pierce)
		
		attack.start()
		
	look_at(target)
	rotation_degrees += 90.0

func take_damage(damage):
	health -= damage
	if health <= 0:
		alive = false

func _on_AttackCD_timeout():
	can_use_attack = true
	
func get_class():
	return "Mob"
