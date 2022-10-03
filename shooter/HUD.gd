extends CanvasLayer

# child nodes
onready var ten_second_timer = $TenSecondTimer
onready var player_health = $PlayerHealth
onready var computer_arrow = $ComputerArrow

const buff_card_scene = preload("res://shooter/BuffCard.tscn")
var buff_cards = []
var next_x = 0
var next_y = 0
const offset_x = 5
const offset_y = 45
var stack_size = 0
var next_stack_size = 19

func _ready():	
	# set the location of the card, should use a better method for future
	next_x = 1920 - 130
	next_y = 130
	
func level_set_up(remove_amount):
	player_health.update_player_health(EntityManager.player.health)
	
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
