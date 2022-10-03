extends Sprite

# preloaded buff textures
const buff_health_texture = preload("res://assets/card-shields.png")
const buff_speed_texture = preload("res://assets/card-speed.png")
const buff_damage_texture = preload("res://assets/card-damage.png")
const buff_amount_texture = preload("res://assets/card-doubleshot.png")
const buff_spawn_texture = preload("res://assets/card-split.png")
const buff_dot_texture = preload("res://assets/card-biohazard.png")
const buff_range_texture = preload("res://assets/card-eye.png")

func show_card(x, y, buff):
	position.x = x
	position.y = y
	
	var buff_text = $BuffText
	var skull = $Skull
	
	self.visible = true
	buff_text.visible = true
	skull.visible = true
	
	match buff:
		"health":
			texture = buff_health_texture
			buff_text.text = "+health"
		"speed":
			texture = buff_speed_texture
			buff_text.text = "+speed"
		"damage":
			texture = buff_damage_texture
			buff_text.text = "+damage"
		"amount":
			texture = buff_amount_texture
			buff_text.text = "+bullets"
		"spawn":
			texture = buff_spawn_texture
			buff_text.text = "+spawn"
		"dot":
			texture = buff_dot_texture
			buff_text.text = "+acid"
		"range":
			texture = buff_range_texture
			buff_text.text = "+range"
