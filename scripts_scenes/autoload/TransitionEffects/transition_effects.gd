extends CanvasLayer

signal transition_finished

@onready var animation_player : AnimationPlayer = $TEAnimationPlayer
@onready var sprite : AnimatedSprite2D = $TEAnimatedSprite2D

var t_purple : String = "transition_purple"
var fo_purple : String = "fade_out_purple"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.visible = false
	animation_player.animation_finished.connect(_on_transition_finished)

# Called when an animation from animation_player has finished playing.
func _on_transition_finished(animation_name : String) -> void:
	if animation_name == t_purple: # if the animation is a fade in purple, plays a fade out
		transition_finished.emit()
		animation_player.play(fo_purple)
	elif animation_name == fo_purple: # if the animation is a fade out, disable sprite's visibility
		sprite.visible = false

# Plays a fade in transition to purple
func transition_purple() -> void:
	sprite.visible = true
	animation_player.play(t_purple)
