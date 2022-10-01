extends Node

# child nodes
onready var ten_second_timer = $TenSecondTimer
onready var hud = $HUD

const test_enemy = preload("res://shooter/test/TestEnemy.tscn")

func _ready():
	randomize()
	
	EntityManager.player = $Player
	$EnemySpawn.spawn(3)

func _process(delta):
	EntityManager.process_enemies()
	EntityManager.remove_dead_enemies()
	
	hud.update_ten_second_timer(ten_second_timer.time_left)

func change_to_scene_signal(score):
	pass
	
# this function is called every ten seconds
# this will add a difficulty modifier to the game
func _on_TenSecondTimer_timeout():
	print("10 seconds")
