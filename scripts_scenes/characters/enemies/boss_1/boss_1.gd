extends Character

const BIG_IMPACT : PackedScene = preload("res://scripts_scenes/particles/big_impact/big_impact_animation.tscn")

@onready var boss_sprite : AnimatedSprite2D = $boss_1_sprite
@onready var boss_healthbar : TextureProgressBar = $CanvasLayer/heart_icon/boss_healthbar

@onready var timer_move_x : Timer = $TimerMoveX
@onready var timer_move_y : Timer = $TimerMoveY
var direction_x : float = -1.0
var direction_y : float = 1.0

func _ready() -> void:
	super._ready()
	boss_sprite.play("default")
	
	boss_healthbar.max_value = max_hp
	update_healthbar()
	
	timer_move_x.start()
	timer_move_y.start()
	
func _physics_process(_delta: float) -> void:
	horizontal_movement()
	vertical_movement()
	move_and_slide()
	
func horizontal_movement() -> void:
	velocity.x = move_toward(velocity.x, speed_max * direction_x, 10.0)
	
func vertical_movement() -> void:
	velocity.y = move_toward(velocity.y, (speed_max * direction_y) / 2.0, 10.0)
	
func setHP(amount : float) -> void:
	super.setHP(amount)
	update_healthbar()
	
	if hp <= 0.0:
		instantiate_obj(BIG_IMPACT, global_position).scale *= 3.0
		queue_free()

func update_healthbar() -> void:
	boss_healthbar.value = hp


func _on_timer_move_timeout() -> void:
	direction_x *= -1.0


func _on_timer_move_y_timeout() -> void:
	direction_y *= -1.0
