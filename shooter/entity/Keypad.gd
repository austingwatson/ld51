extends Area2D

onready var tool_tip = $ToolTip
onready var camera = $Camera2D
onready var animation = $AnimatedSprite

signal zoom_done

var zoom = false
const min_zoom_level = 0.04
const max_zoom_level = 0.4
const zoom_amount = 0.004

func _ready():
	tool_tip.visible = false
	
	self.connect("zoom_done", EntityManager.shooter_game, "change_to_hack_scene")
	
	EntityManager.keypad = self

func _process(delta):
	if EntityManager.enemies.size() == 0:
		animation.play("on")
		tool_tip.text = "Press F to use"
	else:
		animation.play("off")
		tool_tip.text = "Must kill all enemies to use"
		
	if zoom:		
		camera.zoom -= Vector2(zoom_amount, zoom_amount)
		if camera.zoom <= Vector2(min_zoom_level, min_zoom_level):
			camera.zoom = Vector2(min_zoom_level, min_zoom_level)
			zoom = false
			emit_signal("zoom_done")

func _on_Keypad_body_entered(body):
	if body.get_class() == "Player":
		tool_tip.visible = true

func _on_Keypad_body_exited(body):
	if body.get_class() == "Player":
		tool_tip.visible = false

func start_zoom():
	camera.current = true
	camera.zoom = Vector2(max_zoom_level, max_zoom_level)
	zoom = true

func get_class():
	return "Keypad"
