extends Control

# child nodes
onready var ten_second_timer = $TenSecondTimer

export (Texture) var health_texture
const health_y_offset = 50
const health_x = 10
var health_y = 0
var player_health = 10

func _ready():
	health_y = get_viewport_rect().size.y - 42

func _draw():
	var temp_health_y = health_y
	for i in player_health:
		draw_texture_rect(health_texture, Rect2(health_x, health_y, 32, 32), false)
		health_y -= health_y_offset
	health_y = temp_health_y

func update_ten_second_timer(time):
	ten_second_timer.text = str(stepify(time, 1))
	
func update_player_health(health):
	player_health = health
	update()
