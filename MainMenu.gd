extends Node

signal play

var music_db = 0
var sound_db = 0

onready var play_sound = $VBoxContainer/Play/AudioStreamPlayer
onready var music_sound = $VBoxContainer/Music/AudioStreamPlayer
onready var volume_sound = $VBoxContainer/Volume/AudioStreamPlayer
onready var quit_sound = $VBoxContainer/Quit/AudioStreamPlayer
onready var main_menu_music = $MainMenuMusic
onready var play_music_timer = $PlayMusicTimer

var start_music = false

func _ready():
	music_db = AudioServer.get_bus_index("Music")
	sound_db = AudioServer.get_bus_index("Sound")
	
	$VBoxContainer/Music.value = AudioServer.get_bus_volume_db(music_db)
	$VBoxContainer/Volume.value = AudioServer.get_bus_volume_db(music_db)
	
	var root = get_tree().root
	var current_scene = root.get_child(root.get_child_count() - 1)
	self.connect("play", current_scene, "play")

func _input(event):
	if !start_music && event.is_pressed():
		start_music = true
		main_menu_music.play()

func _on_Play_pressed():
	emit_signal("play")

func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(music_db, value)
	if value == 0:
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

func _on_Play_mouse_entered():
	play_sound.play()

func _on_Music_mouse_entered():
	music_sound.play()

func _on_Volume_mouse_entered():
	volume_sound.play()

func _on_Quit_mouse_entered():
	quit_sound.play()

func _on_PlayMusic_timeout():
	main_menu_music.play()

func _on_MainMenuMusic_finished():
	play_music_timer.start()
