extends Node

# child nodes
onready var ten_second_timer = $TenSecondTimer
onready var hud = $HUD

func _ready():
	pass

func _process(delta):
	hud.update_ten_second_timer(ten_second_timer.time_left)

func change_to_scene_signal(score):
	pass
	
# this function is called every ten seconds
# this will add a difficulty modifier to the game
func _on_TenSecondTimer_timeout():
	print("10 seconds")
