extends Control

@export var boss : Character 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_music(SoundManager.MAIN_FIELD_OST, true)

	boss.visible = false
	boss.visibility_canva(false)
	boss.process_mode = Node.PROCESS_MODE_DISABLED
