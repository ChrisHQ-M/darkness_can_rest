extends Bullet

var multiplier : float = 1.0

@onready var aura_sprite : AnimatedSprite2D = $aura_sprite
@onready var bullet_sprite : AnimatedSprite2D = $bullet_sprite
@onready var timer_disappear : Timer = $TimerDisappear

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aura_sprite.play("default")
	bullet_sprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	scale -= Vector2(delta, delta)
	if scale.x <= 0.0:
		queue_free()

func setDirection(dir : Vector2) -> void:
	direction = dir

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area != null && area.is_in_group("Enemy"):
		var body : Character = area.get_parent()
		body.setHP(-dmg_amount * multiplier)
		
		var big_impact : AnimatedSprite2D = instantiate_obj(BIG_IMPACT, global_position)
		big_impact.scale *= max(0.5, multiplier/2.5)
		
		if multiplier > 2.0:
			SoundManager.play_charged_sfx(-5.0, 0.0)
		else:
			SoundManager.play_hit_simple_bullet_sfx(-15.0, 0.0)

		queue_free()

func setMultiplier(amount : float) -> void:
	multiplier += amount
	scale *= max(1.0, multiplier/2.0)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	timer_disappear.start()

func _on_timer_disappear_timeout() -> void:
	queue_free()
