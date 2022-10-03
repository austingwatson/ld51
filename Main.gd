extends Node

const main_menu_scene = preload("res://MainMenu.tscn")
const shooter_game_scene = preload("res://shooter/ShooterGame.tscn")

var current_scene: Node

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -24)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Volume"), -24)
	
	var main_menu = main_menu_scene.instance()
	current_scene = main_menu
	add_child(main_menu)
	
func play():
	current_scene.queue_free()
	var shooter_game = shooter_game_scene.instance()
	current_scene = shooter_game
	add_child(shooter_game)
