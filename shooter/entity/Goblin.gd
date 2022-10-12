extends "Enemy.gd"

onready var plus_health = $PlusHealthLabel

var flee := false

func _ready():
	remove_child(plus_health)
	EntityManager.shooter_game.add_child(plus_health)

func _physics_process(delta):
	if !plus_health.visible && flee:
		var move_direction = position.direction_to(nav_agent.get_next_location())
		velocity = move_direction * -speed
		nav_agent.set_velocity(velocity)
	else:
		velocity = Vector2.ZERO
		
func _process(delta):
	if flee:
		sprite.flip_v = true
	
	look_at(target)
	rotation_degrees += 90.0
	
	if effects.has("dot"):
		acid_overlay.visible = true
	else:
		acid_overlay.visible = false
		
	process_ai(EntityManager.player)
	
	if !plus_health.visible && !alive:
		EntityManager.add_single_stat_to_player("health")
		EntityManager.add_single_stat_to_player("health")
		
		plus_health.visible = true
		plus_health.rect_position = position
		plus_health.rect_position -= plus_health.rect_size / 2
		plus_health.rect_position.y -= 20
		$ShowPlusHealthTimer.start()
		
func process_ai(player):
	if player_in_sight(player.position):
		flee = true
		
	if flee:
		if next_path_find:
			next_path_find = false
			nav_agent.set_target_location(player.position)
		target = player.position

func _on_ShowPlusHealthTimer_timeout():
	plus_health.queue_free()
	queue_free()
