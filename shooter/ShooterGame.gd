extends Node

# child nodes
onready var ten_second_timer = $TenSecondTimer
onready var hud = $HUD

const buff_names = []

var current_level: TileMap

func _init():
	randomize()

func _ready():
	buff_names.append("health")
	buff_names.append("speed")
	buff_names.append("damage")
	
	current_level = $"lvl-facility1"

func _process(delta):
	EntityManager.process_enemies()
	EntityManager.remove_dead_enemies()
	
	hud.update_ten_second_timer(ten_second_timer.time_left)
	
	#print(get_viewport().get_mouse_position())

func change_to_scene_signal(score):
	pass
	
# this function is called every ten seconds
# this will add a difficulty modifier to the game
func _on_TenSecondTimer_timeout():
	var rng = randi() % buff_names.size()
	EntityManager.add_buff_to_enemies(buff_names[rng])
	hud.show_buff_card(buff_names[rng])

func _on_Player_update_health(health):
	hud.update_player_health(health)
	
func player_used_computer():
	ten_second_timer.pause_mode = true
	
	for child in current_level.get_children():
		if child.get_name() == "Keypad":
			child.start_zoom()
