class_name Mob extends "Entity.gd"

# child nodes
onready var attack = $AttackCD

export var max_health = 10
var health = max_health

var target = Vector2.ZERO
var can_use_attack = true
var use_attack = false

func _process(delta):
	if use_attack and can_use_attack:
		can_use_attack = false
		EntityManager.create_projectile(self, target, 300)
		attack.start()
		
	look_at(target)
	rotation_degrees += 90.0

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()

func _on_AttackCD_timeout():
	can_use_attack = true
	
func get_class():
	return "Mob"
