extends CanvasLayer

# found out you should capitalilze scenes
onready var Text = $Text
onready var EndCutsceneTimer = $EndCutsceneTimer

onready var file_path = 'res://assets/cutscene_dialogue.txt'
const dialogue = []

var play_text = false
var text_speed = 0.01

func _ready():
	# open a file and read each line into the dialogue list
	var file = File.new()
	file.open(file_path, File.READ)
	
	while !file.eof_reached():
		dialogue.append(file.get_line())

	file.close()
	
	start_text(0)

func _process(delta):
	if play_text:
		Text.percent_visible += text_speed
		if Text.percent_visible >= 1.0:
			play_text = false
			Text.percent_visible = 1.0
			EndCutsceneTimer.start()

func start_text(index):
	Text.percent_visible = 0
	play_text = true

func _on_EndCutsceneTimer_timeout():
	visible = false
