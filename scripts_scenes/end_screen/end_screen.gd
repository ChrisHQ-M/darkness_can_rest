extends Control

signal text_finished # Sent when all the paragraphs were shown

@export var speed_writing : float = 0.05

@onready var label_intro : Label = $label_intro
@onready var timer_paragraph : Timer = $TimerParagraph
const WAIT_TIME_PARAGRAPH : float = 1.5 # Time before the next paragraph begins to show

var paragraph_1 : String = ""
var paragraph_2 : String = ""
var paragraph_3 : String = ""
var paragraph_4 : String = ""
var paragraph_array : Array[String]
var paragraph_array_length : int

var writing : bool = false
var current_paragraph : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_music(SoundManager.MAIN_MENU_OST, true)
	
	timer_paragraph.wait_time = WAIT_TIME_PARAGRAPH
	
	paragraph_1 = """Wether they are demons or humans, people just won't give up a war."""
	
	paragraph_2 = """Can you blame them though ?
	
	Didn't you just fight one of your kind ?
	
	What's the reason you're still wandering around these fields, carrying the pain of the holy light in your heart ?"""

	paragraph_3 = """To bring peace to demons ? To humans ?
	
	This is something you will have to look for, as you explore a world that you didn't take time to admire."""
	
	paragraph_4 = """And after those errands, darkness can rest."""

	paragraph_array = [paragraph_1, paragraph_2, paragraph_3, paragraph_4]
	paragraph_array_length = len(paragraph_array)
	
	text_finished.connect(_on_text_finished)
	
	show_text()

func show_text() -> void:
	writing = true # Currently writing
	label_intro.text = ""
	
	for character in paragraph_array[current_paragraph]:
		if not writing: # If press enter, shows all the text instead of showing character per character
			break
			
		label_intro.text += character
		await get_tree().create_timer(speed_writing).timeout
		
	label_intro.text = paragraph_array[current_paragraph]
	writing = false
	
	current_paragraph += (1 if current_paragraph < paragraph_array_length else 0)
	
	if current_paragraph < paragraph_array_length: # If it wasn't the last paragraph, show the next in few seconds
		timer_paragraph.start()
	else: # If it was the last paragraph, send signal to change scene
		text_finished.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter") and writing: # Skip the showing text
		writing = false

func _on_timer_paragraph_timeout() -> void:
	show_text()

# Change the scene
func _on_text_finished() -> void:
	await get_tree().create_timer(3.0).timeout
	
	TransitionEffects.transition_purple()
	await TransitionEffects.transition_finished
	
	get_tree().change_scene_to_file("res://scripts_scenes/main_menu/main_menu.tscn")
