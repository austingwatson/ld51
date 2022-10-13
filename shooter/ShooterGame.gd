extends Node

# child nodes
onready var ten_second_timer = $TenSecondTimer
onready var hud = $HUD
onready var player_cutscene = $PlayerCutscene
onready var enemy_cutscene = $EnemyCutscene

signal zoom_out_player

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

const music1 = preload("res://sounds/Chiptune Techno.mp3")
#const music2 = preload("res://sounds/Cyberpunk Moonlight Sonata v2.mp3")
const musics = []

var on_new_level = false

func _init():
	randomize()

func _ready():
	Input.set_custom_mouse_cursor(cursor_image)
	
	EntityManager.shooter_game = self
	
	levels.append(level1_scene)
	levels.append(level2_scene)
	levels.append(level3_scene)
	levels.append(level4_scene)
	levels.append(level5_scene)
	
	musics.append(music1)
	#musics.append(music2)
	
	last_level = randi() % levels.size()
	var level = levels[last_level].instance()
	if level.has_node("LevelModifier"):
		EntityManager.level_modifier = level.get_node("LevelModifier").level_modifier
	
	current_level = level
	add_child(level, 1)
	EntityManager.randomize_keypad()
	
	hud.level_set_up(0)
	
	player_cutscene.start_all()
	get_tree().paused = true

func _input(event):
	pass

func _process(delta):
	EntityManager.process_enemies()
	EntityManager.remove_dead_enemies()
	
	hud.update_ten_second_timer(ten_second_timer.time_left)

func change_from_hack_scene():
	enemy_cutscene.end_cutscene()
	
	current_level.queue_free()
	
	EntityManager.new_level(0)
	
	var next_level = randi() % levels.size()
	while last_level == next_level:
		next_level = randi() % levels.size()
	
	var level = levels[next_level].instance()
	if level.has_node("LevelModifier"):
		EntityManager.level_modifier = level.get_node("LevelModifier").level_modifier
	
	last_level = next_level
	add_child(level)
	EntityManager.randomize_keypad()
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
	var buff = EntityManager.add_buff_to_enemies()
	
	hud.show_buff_card(buff)
	EntityManager.player.ten_second_timer_timeout()

func _on_Player_update_health(health):
	hud.update_player_health(health)
	
func player_used_computer():
	on_new_level = true
	enemy_cutscene.start_random()
	ten_second_timer.paused = true
	
	for child in current_level.get_children():
		if child == EntityManager.keypad:
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
	on_new_level = false
	hud.update_ten_second_timer(9.99)
	EntityManager.restart()
	
	current_level.queue_free()
	var next_level = randi() % levels.size()
	var level = levels[next_level].instance()
	if level.has_node("LevelModifier"):
		EntityManager.level_modifier = level.get_node("LevelModifier").level_modifier
	
	last_level = next_level
	current_level = level
	add_child(level)
	EntityManager.randomize_keypad()
	
	player_cutscene.start_all()
	get_tree().paused = true

func wave_cd_changed(on_cd):
	hud.player_wave_cd(on_cd)

func _on_PlayerCutscene_done_processing():
	EntityManager.spawn_full_enemies()
	
	if on_new_level:
		on_new_level = false
		for child in current_level.get_children():
			if child.get_name() == "Player":
				child.start_zoom()
				#ten_second_timer.start()
				ten_second_timer.paused = false
				break
	
	ten_second_timer.start()
	get_tree().paused = false
