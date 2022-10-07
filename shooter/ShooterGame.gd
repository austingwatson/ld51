extends Node

# child nodes
onready var ten_second_timer = $TenSecondTimer
onready var hud = $HUD

signal zoom_out_player
signal return_to_main_menu

const buff_names = []

# custom cursor
var cursor_image = preload("res://assets/reticule.png")

# levels 
var levels = []
const level1_scene = preload("res://shooter/level/lvl-facility1.tscn")
const level2_scene = preload("res://shooter/level/level-facility1.tscn")
const level3_scene = preload("res://shooter/level/level-teleporterhall.tscn")
const level4_scene = preload("res://shooter/level/level-specimen-storage.tscn")
const level5_scene = preload("res://shooter/level/basic-map.tscn")
var current_level: TileMap
var last_level = 0

# ambient music to use
onready var ambient_music = $AmbientMusic
onready var ambient_music_timer = $AmbientMusicTimer

const music1 = preload("res://sounds/sci-fi-sfx/loop_ambient_01.ogg")
const music2 = preload("res://sounds/computer-room-ambience.mp3")
const musics = []

func _init():
	randomize()

func _ready():
	Input.set_custom_mouse_cursor(cursor_image)
	
	EntityManager.shooter_game = self
	
	buff_names.append("health")
	buff_names.append("speed")
	buff_names.append("damage")
	buff_names.append("amount")
	buff_names.append("dot")
	buff_names.append("range")
	buff_names.append("attack-speed")
	buff_names.append("spawn")
	
	levels.append(level1_scene)
	levels.append(level2_scene)
	levels.append(level3_scene)
	levels.append(level4_scene)
	levels.append(level5_scene)
	last_level = randi() % levels.size()
	var level = levels[last_level].instance()
	add_child(level)
	EntityManager.spawn_full_enemies()
	current_level = level
	hud.level_set_up(0)
	
	musics.append(music1)
	musics.append(music2)
	
	var root = get_tree().root
	var current_scene = root.get_child(root.get_child_count() - 1)
	self.connect("return_to_main_menu", current_scene, "return_to_main_menu")

func _input(event):
	pass

func _process(delta):
	EntityManager.process_enemies()
	EntityManager.remove_dead_enemies()
	
	hud.update_ten_second_timer(ten_second_timer.time_left)

func change_from_hack_scene():
	current_level.queue_free()
	
	EntityManager.new_level(0)
	
	var next_level = randi() % levels.size()
	while last_level == next_level:
		next_level = randi() % levels.size()
	
	var level = levels[next_level].instance()
	last_level = next_level
	add_child(level)
	EntityManager.spawn_full_enemies()
	current_level = level
	hud.level_set_up(0)
	
	for child in current_level.get_children():
		if child.get_name() == "Player":
			child.start_zoom()
			#ten_second_timer.start()
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
	EntityManager.player.ten_second_timer_timeout()

func _on_Player_update_health(health):
	hud.update_player_health(health)
	
func player_used_computer():
	ten_second_timer.paused = true
	
	for child in current_level.get_children():
		if child.get_name() == "Keypad":
			child.start_zoom()
			break

func change_to_hack_scene():
	_on_HUD_paused(true)
	hud.use_computer()

func _on_HUD_paused(paused):
	get_tree().paused = paused

func play_random_music():
	var rng = randi() % musics.size()
	ambient_music.stream = musics[rng]
	ambient_music.play()

func _on_AmbientMusicTimer_timeout():
	play_random_music()

func _on_AmbientMusic_finished():
	ambient_music_timer.start()

func _on_HUD_restart():
	EntityManager.restart()
	
	current_level.queue_free()
	var next_level = randi() % levels.size()
	while last_level == next_level:
		next_level = randi() % levels.size()
	
	var level = levels[next_level].instance()
	last_level = next_level
	add_child(level)
	EntityManager.spawn_full_enemies()
	current_level = level
	
	for child in current_level.get_children():
		if child.get_name() == "Player":
			child.start_zoom()
			#ten_second_timer.start()
			ten_second_timer.paused = false
			break
	
	ten_second_timer.start()
	get_tree().paused = false
