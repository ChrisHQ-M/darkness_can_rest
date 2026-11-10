extends Bullet

var multiplier : float = 1.0 # Dmg bonus multiplier

# Simple bullet's sprites
@onready var aura_sprite : AnimatedSprite2D = $aura_sprite
@onready var bullet_sprite : AnimatedSprite2D = $bullet_sprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aura_sprite.play("default")
	bullet_sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	# The bullet loses size based on time
	scale -= Vector2(delta, delta)
	if scale.x <= 0.0:
		queue_free()


# Sets the direction where the bullet has to move to
func setDirection(dir : Vector2) -> void:
	direction = dir


# Deals damage to enemy when enters in contact
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area != null && area.is_in_group("Enemy"):
		# Get the parent
		var body : Character = area.get_parent()
		body.setHP(-dmg_amount * multiplier)
		
		# Instantiate an impact animation
		var big_impact : AnimatedSprite2D = instantiate_obj(BIG_IMPACT, global_position)
		big_impact.scale *= max(0.5, multiplier/2.5)
		
		# Plays a charged bullet sound or simple one based on multiplier's value
		if multiplier > 2.0:
			SoundManager.play_charged_sfx(-5.0, 0.0)
			GlobalSignals.camera_shake.emit(10.0, 0.5)
			GlobalSignals.engine_slow.emit(0.05, 0.02)
		else:
			SoundManager.play_hit_simple_bullet_sfx(-15.0, 0.0)

		queue_free()


# Sets the multiplier to amount
func setMultiplier(amount : float) -> void:
	multiplier += amount
	scale *= max(1.0, multiplier/2.0)
