extends CanvasLayer

# found out you should capitalilze scenes
onready var Text = $Text
onready var EndCutsceneTimer = $EndCutsceneTimer
onready var KeyPress = $KeyPress

export(int, "Player", "Enemy") var file_path_type := 0
onready var player_file_path = 'res://dialogue/cutscene_dialogue_player.txt'
onready var enemy_file_path = 'res://dialogue/cutscene_dialogue_enemy.txt'
var dialogue = []

var current_dialogue = 0
var dialogue_sequence = []
export(int, "Timed", "Press", "External") var type := 0
var play_text = false
export var text_speed = 1

signal done_processing

func _ready():
	# open a file and read each line into the dialogue list
	var file = File.new()
	if file_path_type == 0:
		file.open(player_file_path, File.READ)
	else:
		file.open(enemy_file_path, File.READ)
	
	while !file.eof_reached():
		var line = file.get_line()
		if !line.empty():
			dialogue.append(line)

	file.close()

func _input(event):
	# check if the current cutscene type is "Press" and if it is ok to press
	if visible && type == 1 && !play_text && event.is_action_released("activate"):
		current_dialogue += 1
		if current_dialogue < dialogue_sequence.size():
			play_text(dialogue_sequence[current_dialogue])
		else:
			current_dialogue = 0
			visible = false
			
			if file_path_type == 0:
				emit_signal("done_processing")

func _process(delta):
	if play_text:
		Text.percent_visible += text_speed * delta
		if Text.percent_visible >= 1.0:
			KeyPress.visible = true
			play_text = false
			Text.percent_visible = 1.0
			
			if type == 0:
				EndCutsceneTimer.start()

func start_text(dialogue_sequence):
	dialogue_sequence.clear()
	visible = true
	self.dialogue_sequence = dialogue_sequence
	
	play_text(dialogue_sequence[current_dialogue])

func start_random():
	dialogue_sequence.clear()
	visible = true
	var rng = randi() % dialogue.size()
	self.dialogue_sequence = [rng]
	
	play_text(dialogue_sequence[current_dialogue])

func start_all():
	dialogue_sequence.clear()
	visible = true
	for i in range(0, dialogue.size()):
		dialogue_sequence.append(i)
	
	play_text(dialogue_sequence[current_dialogue])

func play_text(index):
	KeyPress.visible = false
	Text.text = dialogue[index]
	
	Text.percent_visible = 0
	play_text = true

func end_cutscene():
	current_dialogue = 0
	visible = false
	
	if file_path_type == 0:
		emit_signal("done_processing")

func _on_EndCutsceneTimer_timeout():
	current_dialogue += 1
	if current_dialogue < dialogue_sequence.size():
		play_text(dialogue_sequence[current_dialogue])
	else:
		current_dialogue = 0
		visible = false
		
		if file_path_type == 0:
			emit_signal("done_processing")
