extends CanvasLayer

# buff cards
const buff_health_texture = preload("res://assets/card-maxhp.png")
const buff_speed_texture = preload("res://assets/card-speed.png")
const buff_damage_texture = preload("res://assets/card-damage.png")
const buff_amount_texture = preload("res://assets/card-doubleshot.png")
const buff_dot_texture = preload("res://assets/card-biohazard.png")
const buff_range_texture = preload("res://assets/card-eye.png")
const buff_grenade_texture = preload("res://assets/card-extracell.png")
const buff_debuff_texture = preload("res://assets/card-enemydebuff.png")
const buff_attack_speed_texture = preload("res://assets/card-shields.png")

# child nodes
onready var ten_second_timer = $TenSecondTimer
onready var player_health = $PlayerHealth
onready var pause_menu = $PauseMenu
onready var buff_selector = $BuffSelector
onready var s1_button = $BuffSelector/VBoxContainer/Selection1/S1Button
onready var s2_button = $BuffSelector/VBoxContainer/Selection2/S2Button
onready var s3_button = $BuffSelector/VBoxContainer/Selection3/S3Button
onready var death_screen = $DeathScreen
onready var grenade_amount = $GrenadeAmount

signal paused(paused)
signal done_hacking
signal restart()

const buff_card_scene = preload("res://shooter/BuffCard.tscn")
var buff_cards = []
var next_x = 0
var next_y = 0
const offset_x = 5
const offset_y = 45
var stack_size = 0
var next_stack_size = 19

var in_menu = false
var select_amount = 0
const selected = [false, false, false]
const buffs = []
const buffs_amount = []

var music_db = 0
var sound_db = 0

func _ready():	
	music_db = AudioServer.get_bus_index("Music")
	sound_db = AudioServer.get_bus_index("Sound")
	
	# set the location of the card, should use a better method for future
	next_x = 1920 - 130
	next_y = 130
	
	$PauseMenu/VBoxContainer/Music.value = AudioServer.get_bus_volume_db(music_db)
	$PauseMenu/VBoxContainer/Volume.value = AudioServer.get_bus_volume_db(sound_db)
	pause_menu.visible = false
	buff_selector.visible = false
	
	death_screen.visible = false
	
func _input(event):
	if event.is_action_released("ui_cancel"):
		in_menu = !in_menu
		pause_menu.visible = in_menu
		emit_signal("paused", in_menu)
	if event.is_action_released("restart"):
		if death_screen.visible:
			death_screen.visible = false
			
			for buff_card in buff_cards:
				buff_card.queue_free()
			buff_cards.clear()
			next_x = 1920 - 130
			next_y = 130
			stack_size = 0
			next_stack_size = 19
			
			emit_signal("restart")
	
func _process(delta):
	if select_amount == 2:
		for i in selected.size():
			if selected[i]:
				EntityManager.add_single_stat_to_player(buffs[i])
				if buffs[i] == "debuff":
					remove_buffs(2)
				
		select_amount = 0
		buff_selector.visible = false
		s1_button.set_pressed_no_signal(false)
		s2_button.set_pressed_no_signal(false)
		s3_button.set_pressed_no_signal(false)
		emit_signal("paused", false)
		emit_signal("done_hacking")
	
	grenade_amount.text = str(EntityManager.player.grenades)
		
	if EntityManager.player.health <= 0:
		emit_signal("paused", true)
		death_screen.visible = true
	
func level_set_up(remove_amount):
	player_health.update_player_health(EntityManager.player.health)
	remove_buffs(remove_amount)

func remove_buffs(remove_amount):
	var lower = buff_cards.size() - 1 - remove_amount
	if lower <= 0:
		lower = 0
	for i in range(buff_cards.size() - 1, lower, -1):
		var buff_card = buff_cards[i]
		buff_card.queue_free()
		buff_cards.remove(i)
		
		stack_size -= 1
		next_y -= offset_y
		if next_y < 130:
			next_y = 940
			next_x -= offset_x
			next_stack_size -= 19

func update_ten_second_timer(time):
	ten_second_timer.text = "%.2f" % time
	
func update_player_health(health):
	player_health.update_player_health(health)

func show_buff_card(buff):
	var buff_card = buff_card_scene.instance()
	buff_card.show_card(next_x, next_y, buff)
	buff_cards.append(buff_card)
	next_y += offset_y
	
	stack_size += 1
	if stack_size >= next_stack_size:
		next_stack_size += 19
		next_y = 130
		next_x += offset_x
	
	add_child(buff_card)
	
func use_computer():
	buffs.clear()
	select_amount = 0
	selected[0] = false
	selected[1] = false
	selected[2] = false
	buff_selector.visible = true
	
	for i in 3:
		var select_button = get_node("BuffSelector/VBoxContainer/Selection%d/S%dButton" % [(i + 1), (i + 1)])
		var select_label = get_node("BuffSelector/VBoxContainer/Selection%d/S%dButton/Label%d" % [(i + 1), (i + 1), (i + 1)])
		
		var rng = randi() % 9 # amount of buff cards the player can get
		match rng:
			0:
				select_button.texture_normal = buff_health_texture
				select_label.text = "+health"
				buffs.append("health")
			1:
				select_button.texture_normal = buff_speed_texture
				select_label.text = "+speed"
				buffs.append("speed")
			2:
				select_button.texture_normal = buff_damage_texture
				select_label.text = "+damage"
				buffs.append("damage")
			3:
				select_button.texture_normal = buff_amount_texture
				select_label.text = "+bullet"
				buffs.append("amount")
			4:
				select_button.texture_normal = buff_dot_texture
				select_label.text = "+acid"
				buffs.append("dot")
			5:
				select_button.texture_normal = buff_range_texture
				select_label.text = "+range"
				buffs.append("range")
			6:
				select_button.texture_normal = buff_grenade_texture
				select_label.text = "+grenade"
				buffs.append("grenade")
			7:
				select_button.texture_normal = buff_debuff_texture
				select_label.text = "-enemy"
				buffs.append("debuff")
			8:
				select_button.texture_normal = buff_attack_speed_texture
				select_label.text = "+atk-speed"
				buffs.append("attack-speed")
		
	
func _on_Play_pressed():
	in_menu = false
	pause_menu.visible = in_menu
	emit_signal("paused", in_menu)

func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(music_db, value)
	if value == -60:
		AudioServer.set_bus_mute(music_db, true)
	else:
		AudioServer.set_bus_mute(music_db, false)

func _on_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(sound_db, value)
	if value == -60:
		AudioServer.set_bus_mute(sound_db, true)
	else:
		AudioServer.set_bus_mute(sound_db, false)

func _on_Quit_pressed():
	get_tree().quit()

func _on_S1Button_toggled(button_pressed):
	selected[0] = button_pressed
	if button_pressed:
		select_amount += 1
	else:
		select_amount -= 1

func _on_S2Button_toggled(button_pressed):
	selected[1] = button_pressed
	if button_pressed:
		select_amount += 1
	else:
		select_amount -= 1

func _on_S3Button_toggled(button_pressed):
	selected[2] = button_pressed
	if button_pressed:
		select_amount += 1
	else:
		select_amount -= 1
