extends CanvasLayer

# found out you should capitalilze scenes
onready var Text = $Text
onready var EndCutsceneTimer = $EndCutsceneTimer

export(int, "Player", "Enemy") var file_path_type := 0
onready var player_file_path = 'res://assets/cutscene_dialogue_player.txt'
onready var enemy_file_path = 'res://assets/cutscene_dialogue_enemy.txt'
const dialogue = []

var current_dialogue = 0
var dialogue_sequence = []
export(int, "Timed", "Press") var type := 0
var play_text = false
export var text_speed = 1

func _input(event):
	# check if the current cutscene type is "Press" and if it is ok to press
	if visible && type == 1 && !play_text && event.is_action_released("activate"):
		current_dialogue += 1
		if current_dialogue < dialogue_sequence.size():
			play_text(dialogue_sequence[current_dialogue])
		else:
			current_dialogue = 0
			visible = false

func _ready():
	# open a file and read each line into the dialogue list
	var file = File.new()
	if file_path_type == 0:
		file.open(player_file_path, File.READ)
	else:
		file.open(enemy_file_path, File.READ)
	
	while !file.eof_reached():
		dialogue.append(file.get_line())

	file.close()
	
	start_text([0, 1])

func _process(delta):
	if play_text:
		Text.percent_visible += text_speed * delta
		if Text.percent_visible >= 1.0:
			play_text = false
			Text.percent_visible = 1.0
			
			if type == 0:
				EndCutsceneTimer.start()

func start_text(dialogue_sequence):
	self.dialogue_sequence = dialogue_sequence
	
	play_text(dialogue_sequence[current_dialogue])

func play_text(index):
	Text.text = dialogue[index]
	
	Text.percent_visible = 0
	play_text = true

func _on_EndCutsceneTimer_timeout():
	current_dialogue += 1
	if current_dialogue < dialogue_sequence.size():
		play_text(dialogue_sequence[current_dialogue])
	else:
		current_dialogue = 0
		visible = false
