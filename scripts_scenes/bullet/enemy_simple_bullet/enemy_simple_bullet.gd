extends Bullet

@onready var sprite : AnimatedSprite2D = $sprite
@onready var timer_disappear : Timer = $TimerDisappear

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")

func _on_timer_disappear_timeout() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	timer_disappear.start()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area != null && area.is_in_group("Player"):
		var body : Character = area.get_parent()
		body.setHP(-dmg_amount)
		SoundManager.play_hit_sfx(-5.0, 0.0)
		
		var big_impact : AnimatedSprite2D = instantiate_obj(BIG_IMPACT, global_position)
		big_impact.scale *= 0.5
		
		queue_free()
