extends AnimatedSprite2D

const DMG_BONUS : float = 0.35

# Moves up and down every timeout
@onready var timer_move : Timer = $TimerMove
const SPEED : float = 10.0
var direction_y : float = -1.0

# Impact animation to instantiate
const BIG_IMPACT_ANIMATION : PackedScene = preload("res://scripts_scenes/particles/big_impact/big_impact_animation.tscn")


# Called when enter the node for the first time
func _ready() -> void:
	timer_move.start()
	play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y += SPEED * delta * direction_y


# Changes the vertical direction every timeout (up and down)
func _on_timer_move_timeout() -> void:
	direction_y *= -1.0


# Adds bonus to the player when enter in contact
func _on_pick_area_body_entered(body: Node2D) -> void:
	if body != null && body.is_in_group("Player"):
		body.addDMGbonus(DMG_BONUS)
		SoundManager.play_healing_sfx(0.0, -0.5)
		
		# Instantiate an impact animation
		var big_impact : AnimatedSprite2D = BIG_IMPACT_ANIMATION.instantiate()
		big_impact.global_position = global_position
		big_impact.scale *= 0.75
		get_tree().current_scene.add_child(big_impact)
		
		queue_free()
