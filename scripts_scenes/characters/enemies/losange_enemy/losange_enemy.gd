extends CharacterBody2D

@onready var losange_sprite : AnimatedSprite2D = $losange_sprite

const BODY_DMG : float = 2.0
var max_hp : float = 30.0
var hp : float

@onready var timer_move : Timer = $TimerMove
var direction_x : float = 1.0
const SPEED = 75.0
const JUMP_VELOCITY = -400.0
const GRAVITY : float = 300.0

func _ready() -> void:
	hp = max_hp
	losange_sprite.play("idle")
	
	timer_move.start()

func _physics_process(delta: float) -> void:
	vertical_movement(delta)
	horizontal_movement(delta)
	move_and_slide()

func horizontal_movement(delta : float) -> void:
	velocity.x = move_toward(velocity.x, SPEED * direction_x, SPEED/10.0)

func vertical_movement(delta : float) -> void:
	if not is_on_floor():
		velocity.y += delta * GRAVITY

func setHP(amount : float) -> void:
	var new_hp : float = hp + amount
	
	if new_hp < 0.0:
		queue_free()
	elif new_hp > max_hp:
		hp = max_hp
	else:
		hp = new_hp


func _on_timer_move_timeout() -> void:
	direction_x *= -1.0


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area != null && area.is_in_group("Player"):
		area.get_parent().setHP(-BODY_DMG)
