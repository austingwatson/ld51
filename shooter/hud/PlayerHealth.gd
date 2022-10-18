extends Control

onready var extra_health = $ExtraHealth

export (AnimatedTexture) var health_texture
export (Texture) var health_bulb
const health_y_offset = 32
const health_x = 99
var health_y = 0
const health_size = 32

var player_health = 10
var draw_health_bulb = false

func _ready():
	health_y = get_viewport_rect().size.y - health_size - 177

func _draw():
	if draw_health_bulb:
		draw_texture_rect(health_bulb, Rect2(52, 23, 128, 128), false)
	
	var temp_health_y = health_y
	for i in player_health:
		draw_texture_rect(health_texture, Rect2(health_x, health_y, health_size, health_size), false)
		health_y -= health_y_offset
	health_y = temp_health_y

func update_player_health(health):
	if health > 29:
		extra_health.text = str(health - 24)
		extra_health.visible = true
		
		health = 24
		draw_health_bulb = true
	else:
		draw_health_bulb = false
		extra_health.visible = false
		
	player_health = health
	update()
