extends CanvasLayer

# child nodes
onready var ten_second_timer = $TenSecondTimer
onready var player_health = $PlayerHealth

const buff_card_scene = preload("res://shooter/BuffCard.tscn")
var buff_cards = []
var next_x = 0
var next_y = 0

func _ready():
	player_health.update_player_health(EntityManager.player.health)
	
	next_x = 1920 - 118
	next_y = 170

func update_ten_second_timer(time):
	ten_second_timer.text = "%.2f" % time
	
func update_player_health(health):
	player_health.update_player_health(health)

func show_buff_card(buff):
	var buff_card = buff_card_scene.instance()
	buff_card.show_card(next_x, next_y, buff)
	next_y += 40
	
	add_child(buff_card)
