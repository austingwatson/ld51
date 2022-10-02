class_name Mob extends KinematicBody2D

# child nodes
onready var attack = $AttackCD

export var max_health = 1
var health = 1
var alive = true

export var speed = 300
var velocity = Vector2.ZERO

# current projectile information
# would like to learn how to do this more oop
var target = Vector2.ZERO
var can_use_attack = true
var use_attack = false
export var projectile_speed = 1000
export var projectile_range = 400
export var projectile_damage = 1
export var projectile_pierce = 1
export var projectile_amount = 1
export var projectile_accuracy = 1.0
export var projectile_dot_tick = 0

var effects = {}

func _ready():
	health = max_health

func _physics_process(delta):
	velocity = move_and_slide(velocity)

func _process(delta):
	if use_attack and can_use_attack:
		can_use_attack = false
		EntityManager.create_projectile(self, target, projectile_speed, projectile_accuracy, projectile_range, projectile_damage, projectile_pierce, projectile_dot_tick)
		
		for i in range(1, projectile_amount):
			EntityManager.create_projectile(self, target, projectile_speed, projectile_accuracy - 0.1, projectile_range, projectile_damage, projectile_pierce, projectile_dot_tick)
		
		attack.start()
		
	look_at(target)
	rotation_degrees += 90.0

func take_damage(damage):
	health -= damage
	if health <= 0:
		alive = false
		
func add_dot(ticks):
	if effects.has("dot"):
		if ticks > effects["dot"]:
			effects["dot"] = ticks
	else:
		effects["dot"] = ticks

func _on_AttackCD_timeout():
	can_use_attack = true
	
func get_class():
	return "Mob"


func _on_DotTimer_timeout():
	if effects.has("dot"):
		take_damage(1)
		effects["dot"] = effects["dot"] - 1
		if effects["dot"] == 0:
			effects.erase("dot")
