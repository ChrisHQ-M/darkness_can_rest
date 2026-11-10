extends CharacterEnemy

# Sprite
@onready var losange_sprite : AnimatedSprite2D = $losange_sprite

# Movements attributes
@onready var timer_move : Timer = $TimerMove
var direction_x : float = 1.0

# Called when enter the node for the first time
func _ready() -> void:
	super._ready()
	losange_sprite.play("idle")
	
	timer_move.start()

# Called every tick to manage the losange's movements
func _physics_process(delta: float) -> void:
	vertical_movement(delta)
	horizontal_movement()
	move_and_slide()

func horizontal_movement() -> void:
	velocity.x = move_toward(velocity.x, speed_max * direction_x, speed_max/10.0)

func vertical_movement(delta : float) -> void:
	if not is_on_floor():
		velocity.y += delta * gravity

# Every timer_move.wait_time seconds, changes the direction (left or right) of the losange
func _on_timer_move_timeout() -> void:
	direction_x *= -1.0

# Deals BODY_DMG to the player if the losange touches their hitbox
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area != null && area.is_in_group("Player"):
		area.get_parent().setHP(-body_dmg)
		
		SoundManager.play_hit_sfx(-5.0, 0.0)
		instantiate_obj(BIG_IMPACT, global_position)
		GlobalSignals.camera_shake.emit(5.0, 0.5)
		GlobalSignals.engine_slow.emit(0.35, 0.1)
