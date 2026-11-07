extends AnimatedSprite2D

const DEFAULT : String = "default" # Animation name

# Called when the node enters the scene tree for the first time. Plays the animation then frees the node when finished.
func _ready() -> void:
	play(DEFAULT)
	await animation_finished
	queue_free()
	
