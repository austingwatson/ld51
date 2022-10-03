extends Node

# child nodes
onready var ten_second_timer = $TenSecondTimer
onready var hud = $HUD

signal zoom_out_player

const buff_names = []

# levels 
const level_amount = 2
var levels = []
const level1_scene = preload("res://shooter/level/lvl-facility1.tscn")
const level2_scene = preload("res://shooter/level/level-facility1.tscn")
var current_level: TileMap
var last_level = 0

func _init():
	randomize()

func _ready():
	var cursor_image = load("res://assets/reticule.png")
	Input.set_custom_mouse_cursor(cursor_image, Input.CURSOR_ARROW, Vector2(8, 8))
	
	buff_names.append("health")
	buff_names.append("speed")
	buff_names.append("damage")
	buff_names.append("amount")
	buff_names.append("dot")
	buff_names.append("range")
	buff_names.append("spawn")
	
	levels.append(level1_scene)
	levels.append(level2_scene)
	last_level = randi() % levels.size()
	var level = levels[last_level].instance()
	add_child(level)
	EntityManager.spawn_full_enemies()
	current_level = level
	hud.level_set_up(0)

func _process(delta):
	EntityManager.process_enemies()
	EntityManager.remove_dead_enemies()
	
	hud.update_ten_second_timer(ten_second_timer.time_left)

func change_from_hack_scene(score):
	current_level.queue_free()
	EntityManager.new_level(3)
	
	var next_level = randi() % levels.size()
	print(last_level, ", ", next_level)
	while last_level == next_level:
		next_level = randi() % levels.size()
	
	var level = levels[next_level].instance()
	last_level = next_level
	add_child(level)
	EntityManager.spawn_full_enemies()
	current_level = level
	hud.level_set_up(3)
	
	for child in current_level.get_children():
		if child.get_name() == "Player":
			child.start_zoom()
			ten_second_timer.start()
			ten_second_timer.paused = false
			break
	
# this function is called every ten seconds
# this will add a difficulty modifier to the game
func _on_TenSecondTimer_timeout():
	# randomize the next enemy buff card
	# if all enemies are dead, no more can spawn
	# this level, but other cards can work
	var rng = 0
	if EntityManager.enemies.size() == 0:
		rng = randi() % (buff_names.size() - 1)
	else:
		rng = randi() % buff_names.size()
	EntityManager.add_buff_to_enemies(buff_names[rng])
	hud.show_buff_card(buff_names[rng])

func _on_Player_update_health(health):
	hud.update_player_health(health)
	
func player_used_computer():
	ten_second_timer.paused = true
	
	for child in current_level.get_children():
		if child.get_name() == "Keypad":
			child.start_zoom()
			break

func change_to_hack_scene():
	print("change to hack scene")
	change_from_hack_scene(100)
