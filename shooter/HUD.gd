extends Control

# child nodes
onready var ten_second_timer = $TenSecondTimer

export (Texture) var health_texture
const health_x_offset = 50
var health_x = 10
const health_y = 500
var player_health = 10

func _draw():
	for i in player_health:
		draw_texture_rect(health_texture, Rect2(health_x, health_y, 32, 32), false)
		health_x += health_x_offset

func update_ten_second_timer(time):
	ten_second_timer.text = str(stepify(time, 1))
	
func update_player_health(health):
	player_health = health
	update()
