extends Sprite2D

# Sprite for shrine's decorations
@onready var ball_left : AnimatedSprite2D = $ball_left
@onready var ball_right : AnimatedSprite2D = $ball_right

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball_left.play("default")
	ball_right.play("default")
