extends Node

# child nodes
onready var ten_second_timer = $TenSecondTimer
onready var hud = $HUD

func _ready():
	randomize()

func _process(delta):
	EntityManager.process_enemies()
	EntityManager.remove_dead_enemies()
	
	hud.update_ten_second_timer(ten_second_timer.time_left)

func change_to_scene_signal(score):
	pass
	
# this function is called every ten seconds
# this will add a difficulty modifier to the game
func _on_TenSecondTimer_timeout():
	EntityManager.add_buff_to_enemies("health")
	hud.show_buff_card("health")

func _on_Player_update_health(health):
	hud.update_player_health(health)
