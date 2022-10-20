extends CanvasLayer

# found out you should capitalilze scenes
onready var Text = $Text
onready var EndCutsceneTimer = $EndCutsceneTimer
onready var KeyPress = $KeyPress

export(int, "Player", "Enemy") var file_path_type := 0
#onready var player_file_path = 'res://dialogue/cutscene_dialogue_player.txt'
#onready var enemy_file_path = 'res://dialogue/cutscene_dialogue_enemy.txt'
var dialogue = []

var current_dialogue = 0
var dialogue_sequence = []
export(int, "Timed", "Press", "External") var type := 0
var play_text = false
export var text_speed = 1

signal done_processing

func _ready():
	# open a file and read each line into the dialogue list
	# doesnt seem to work on html client
	#var file = File.new()
	#if file_path_type == 0:
	#	file.open(player_file_path, File.READ)
	#else:
	#	file.open(enemy_file_path, File.READ)
	
	#while !file.eof_reached():
	#	var line = file.get_line()
	#	if !line.empty():
	#		dialogue.append(line)

	#file.close()
	
	if file_path_type == 0:
		dialogue.append("Suit power is nominal. No time to waste.")
		dialogue.append("They know I'm here. I'll have to find a TERMINAL and destroy any security forces before I can breach their TRANSPORT NETWORK.")
		dialogue.append("Ready to breach!")
	else:
		dialogue.append("Ha, that was but one of this facility's many levels.")
		dialogue.append("You can AUGMENT yourself all you want. It won't help you stop me.")
		dialogue.append("That suit's ABILITIES won't save you...")
		dialogue.append("You're quite an interesting SPECIMEN. Perhaps your remains will further my RESEARCH.")
		dialogue.append("You're just more biomass for the vats!")
		dialogue.append("None of my algorithms predicted THIS. I must update their DATASETS...")
		dialogue.append("Get out of this SYSTEM!")
		dialogue.append("...HOW?!")
		dialogue.append("...It seems I must ACCELERATE the program.")
		dialogue.append("That was just a taste of this facility's defenses.")
		dialogue.append("That DATA is not for YOU!")
		dialogue.append("How has the TRANSPORT NETWORK not locked you out already...")
		dialogue.append("Spoil my DATA will you? I have redundant ARCHIVES for this exact scenario.")
		dialogue.append("You're sealed in here with my PROJECTS now. You can't survive!")
		dialogue.append("Keep my DATA out of your MEMORY BANKS.")
		dialogue.append("I will PURGE you from this FACILITY.")

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
		Text.visible_characters += text_speed
		if Text.visible_characters >= Text.text.length():
			if type == 1:
				KeyPress.visible = true
			else:
				KeyPress.visible = false
			play_text = false
			#Text.percent_visible = 1.0
			
			if type == 0:
				EndCutsceneTimer.start()

func change_type(type):
	self.type = type

func start_text(dialogue_sequence):
	self.dialogue_sequence.clear()
	visible = true
	self.dialogue_sequence.append_array(dialogue_sequence)
	
	current_dialogue = 0
	play_text(self.dialogue_sequence[current_dialogue])

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
	
	Text.visible_characters = 0
	play_text = true

func end_cutscene():
	current_dialogue = 0
	visible = false
	
	if file_path_type == 0 && type == 1:
		emit_signal("done_processing")

func _on_EndCutsceneTimer_timeout():
	current_dialogue += 1
	if current_dialogue < dialogue_sequence.size():
		play_text(dialogue_sequence[current_dialogue])
	else:
		current_dialogue = 0
		visible = false
		
		if file_path_type == 0 && type == 1:
			emit_signal("done_processing")
