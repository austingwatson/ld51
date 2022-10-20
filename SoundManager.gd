extends Node

var player_shot: AudioStreamPlayer
var drone_shot: AudioStreamPlayer
var soldier_shot: AudioStreamPlayer
var player_melee: AudioStreamPlayer
var player_grenade: AudioStreamPlayer
var player_grenade_explosion: AudioStreamPlayer
var chem_thrower_shot: AudioStreamPlayer
var player_death: AudioStreamPlayer
var teleport: AudioStreamPlayer

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	
	player_shot = AudioStreamPlayer.new()
	player_shot.stream = preload("res://sounds/sci-fi-sfx/misc_04.ogg")
	player_shot.bus = "Sound"
	add_child(player_shot)
	
	drone_shot = AudioStreamPlayer.new()
	drone_shot.stream = preload("res://sounds/sci-fi-sfx/misc_08.ogg")
	drone_shot.bus = "Sound"
	add_child(drone_shot)
	
	soldier_shot = AudioStreamPlayer.new()
	soldier_shot.stream = preload("res://sounds/sci-fi-sfx/misc_01.ogg")
	soldier_shot.bus = "Sound"
	add_child(soldier_shot)
	
	player_melee = AudioStreamPlayer.new()
	player_melee.stream = preload("res://sounds/sci-fi-sfx/teleport_01.ogg")
	player_melee.bus = "Sound"
	add_child(player_melee)
	
	player_grenade = AudioStreamPlayer.new()
	player_grenade.stream = preload("res://sounds/sci-fi-sfx/misc_02.ogg")
	player_grenade.bus = "Sound"
	add_child(player_grenade)
	
	player_grenade_explosion = AudioStreamPlayer.new()
	player_grenade_explosion.stream = preload("res://sounds/sci-fi-sfx/retro_explosion.ogg")
	player_grenade_explosion.bus = "Sound"
	add_child(player_grenade_explosion)
	
	chem_thrower_shot = AudioStreamPlayer.new()
	chem_thrower_shot.stream = preload("res://sounds/sci-fi-sfx/weird_01.ogg")
	chem_thrower_shot.bus = "Sound"
	add_child(chem_thrower_shot)
	
	player_death = AudioStreamPlayer.new()
	player_death.stream = preload("res://sounds/player/die2.wav")
	player_death.bus = "Sound"
	add_child(player_death)
	
	teleport = AudioStreamPlayer.new()
	teleport.stream = preload("res://sounds/player/teleport_02.ogg")
	teleport.bus = "Sound"
	add_child(teleport)

func play_sound(name):
	match name:
		"player-shot":
			if !player_shot.playing:
				player_shot.play()
		"drone-shot":
			if !drone_shot.playing:
				drone_shot.play()
		"soldier-shot":
			if !soldier_shot.playing:
				soldier_shot.play()
		"player-melee":
			if !player_melee.playing:
				player_melee.play()
		"player-grenade":
			if !player_grenade.playing:
				player_grenade.play()
		"player-grenade-explosion":
			if !player_grenade_explosion.playing:
				player_grenade_explosion.play()
		"chem-thrower-shot":
			if !chem_thrower_shot.playing:
				chem_thrower_shot.play()
		"player-death":
			if !player_death.playing:
				player_death.play()
		"teleport":
			if !teleport.playing:
				teleport.play(0.0)
