extends CanvasLayer

# child nodes
onready var ten_second_timer = $TenSecondTimer
onready var buff_card = $BuffCard
onready var buff_card_timer = $BuffCardTimer
onready var buff_card_text = $BuffText
onready var enemy_label = $EnemyLabel
onready var player_health = $PlayerHealth

# preloaded buff textures
const buff_health_texture = preload("res://assets/card-shields.png")
const buff_speed_texture = preload("res://assets/card-speed.png")
const buff_damage_texture = preload("res://assets/card-damage.png")

func _ready():
	buff_card.visible = false
	buff_card_text.visible = false
	enemy_label.visible = false
	
	player_health.update_player_health(EntityManager.player.health)

func update_ten_second_timer(time):
	ten_second_timer.text = "%.2f" % time
	
func update_player_health(health):
	player_health.update_player_health(health)
	
func show_buff_card(buff):
	buff_card_timer.start()
	buff_card.visible = true
	buff_card_text.visible = true
	enemy_label.visible = true
	match buff:
		"health":
			buff_card.texture = buff_health_texture
			buff_card_text.text = "+health"
		"speed":
			buff_card.texture = buff_speed_texture
			buff_card_text.text = "+speed"
		"damage":
			buff_card.texture = buff_damage_texture
			buff_card_text.text = "+damage"

func _on_BuffCardTimer_timeout():
	buff_card.visible = false
	buff_card_text.visible = false
	enemy_label.visible = false
