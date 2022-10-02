extends Area2D

onready var tool_tip = $ToolTip
onready var camera = $Camera2D
onready var animation = $AnimatedSprite

signal zoom_done

var zoom = false

func _ready():
	tool_tip.visible = false
	
	var root = get_tree().root
	var current_scene = root.get_child(root.get_child_count() - 1)
	self.connect("zoom_done", current_scene, "change_to_hack_scene")

func _process(delta):
	if EntityManager.enemies.size() == 0:
		animation.play("off")
		tool_tip.text = "Press F to use"
	else:
		animation.play("on")
		tool_tip.text = "Must kill all enemies to use"
		
	if zoom:		
		camera.zoom -= Vector2(.005, .005)
		if camera.zoom <= Vector2(0.05, 0.05):
			camera.zoom = Vector2(0.05, 0.05)
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
	camera.zoom = Vector2(0.5, 0.5)
	zoom = true

func get_class():
	return "Keypad"
