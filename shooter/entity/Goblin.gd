extends "Enemy.gd"

onready var plus_health = $PlusHealthLabel

var flee := false

func _ready():
	nav_agent.set_target_location(position)
	
	remove_child(plus_health)
	EntityManager.shooter_game.add_child(plus_health)
	
	alive = true

func _physics_process(delta):
	if !plus_health.visible && flee:
		var move_direction = position.direction_to(nav_agent.get_next_location())
		velocity = move_direction * -speed
		velocity = move_and_slide(velocity)
		nav_agent.set_velocity(velocity)
	else:
		velocity = Vector2.ZERO
		
func _process(delta):
	process_ai(EntityManager.player)
	
	if flee:
		animation.play("default")
		sprite.flip_v = true
	else:
		animation.stop()
	
	if dot_amount > 0:
		acid_overlay.visible = true
	else:
		acid_overlay.visible = false
	
	if !alive:
		animation.play("dead")
		
		if !plus_health.visible:
			EntityManager.add_single_stat_to_player("health")
			EntityManager.add_single_stat_to_player("health")
			EntityManager.player.max_health += 2
			EntityManager.player.health += 2
			EntityManager.player.force_hud_update()
		
			plus_health.visible = true
			plus_health.rect_position = position
			plus_health.rect_position -= plus_health.rect_size / 2
			plus_health.rect_position.y -= 20
			$PlusHealthTimer.start()
	else:
		look_at(target)
		rotation_degrees += 90.0
		
func process_ai(player):
	if !alive:
		return
	
	if player_in_sight(player.position):
		flee = true
		
	if flee:
		if next_path_find:
			next_path_find = false
			nav_agent.set_target_location(player.position)
		target = player.position

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	pass

func _on_PlusHealthTimer_timeout():
	plus_health.visible = false
	plus_health.queue_free()
	EntityManager.goblin = null
	queue_free()
