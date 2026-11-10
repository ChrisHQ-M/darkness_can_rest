extends Bullet

@onready var sprite : AnimatedSprite2D = $sprite_square_bullet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")

func _process(delta: float) -> void:
	super._process(delta)
	rotation_degrees += delta * speed


# Deals damage to the player if enters in contact
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area != null && area.is_in_group("Player"):
		var body : Character = area.get_parent()
		body.setHP(-dmg_amount)
		SoundManager.play_hit_sfx(-5.0, 0.0)
		
		# Instantiate impact animation
		var big_impact : AnimatedSprite2D = instantiate_obj(BIG_IMPACT, global_position)
		big_impact.scale *= 0.5
		
		GlobalSignals.camera_shake.emit(10.0, 0.5)
		
		queue_free()
