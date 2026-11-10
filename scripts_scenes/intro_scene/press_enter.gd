extends Label

const TIME_BEFORE_FREE : float = 6.0
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Makes the text flicker before freeing itself
	animation_player.play("fading")
	await get_tree().create_timer(TIME_BEFORE_FREE).timeout
	queue_free()
