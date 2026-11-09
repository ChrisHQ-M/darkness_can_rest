extends Character

@onready var losange_sprite : AnimatedSprite2D = $losange_sprite

const BODY_DMG : float = 2.0

@onready var timer_move : Timer = $TimerMove
var direction_x : float = 1.0


func _ready() -> void:
	super._ready()
	losange_sprite.play("idle")
	
	timer_move.start()

func _physics_process(delta: float) -> void:
	vertical_movement(delta)
	horizontal_movement()
	move_and_slide()

func horizontal_movement() -> void:
	velocity.x = move_toward(velocity.x, speed_max * direction_x, speed_max/10.0)

func vertical_movement(delta : float) -> void:
	if not is_on_floor():
		velocity.y += delta * gravity

func setHP(amount : float) -> void:
	super.setHP(amount)
	
	if hp <= 0.0:
		queue_free()

func _on_timer_move_timeout() -> void:
	direction_x *= -1.0

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area != null && area.is_in_group("Player"):
		area.get_parent().setHP(-BODY_DMG)
