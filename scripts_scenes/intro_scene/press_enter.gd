extends Label

@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fading")
	await get_tree().create_timer(6.0).timeout
	queue_free()
