extends Sprite

# preloaded buff textures
const buff_health_texture = preload("res://assets/card-shields.png")
const buff_speed_texture = preload("res://assets/card-speed.png")
const buff_damage_texture = preload("res://assets/card-damage.png")

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
