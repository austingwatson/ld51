extends Node

signal play

func _ready():
	$VBoxContainer/Music.value = SoundManager.music_volume
	$VBoxContainer/Volume.value = SoundManager.sound_volume
	
	var root = get_tree().root
	var current_scene = root.get_child(root.get_child_count() - 1)
	self.connect("play", current_scene, "play")

func _on_Play_pressed():
	emit_signal("play")

func _on_Music_value_changed(value):
	SoundManager.music_volume = value

func _on_Volume_value_changed(value):
	SoundManager.sound_volume = value

func _on_Quit_pressed():
	get_tree().quit()
