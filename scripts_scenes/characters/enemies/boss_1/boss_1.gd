extends Character

const BIG_IMPACT : PackedScene = preload("res://scripts_scenes/particles/big_impact/big_impact_animation.tscn")

@onready var boss_sprite : AnimatedSprite2D = $boss_1_sprite
@onready var boss_healthbar : TextureProgressBar = $CanvasLayer/heart_icon/boss_healthbar

@onready var timer_move_x : Timer = $TimerMoveX
@onready var timer_move_y : Timer = $TimerMoveY
var direction_x : float = -1.0
var direction_y : float = 1.0

@export var target : Character
const SIMPLE_BULLET : PackedScene = preload("res://scripts_scenes/bullet/enemy_simple_bullet/enemy_simple_bullet.tscn")
const SQUARE_BOMB : PackedScene = preload("res://scripts_scenes/bullet/enemy_square_bullet/enemy_square_bomb.tscn")
@onready var timer_atk : Timer = $TimerATK
const NAME_ATK : Array[String] = ["simple_bullet", "square_bomb"]
@onready var timer_simple_bullet : Timer = $TimerSimpleBullet
@onready var timer_square_bomb : Timer = $TimerSquareBomb

const HEALING_PACK : PackedScene = preload("res://scripts_scenes/pickable/healing_pack/healing_pack.tscn")
@onready var timer_healing_pack : Timer = $TimerHealingPack

var phase : int = 1

func _ready() -> void:
	super._ready()
	boss_sprite.play("default")
	
	boss_healthbar.max_value = max_hp
	update_healthbar()
	
	timer_move_x.start()
	timer_move_y.start()
	timer_atk.start()
	timer_healing_pack.start()
	
func _physics_process(_delta: float) -> void:
	horizontal_movement()
	vertical_movement()
	move_and_slide()
	
func horizontal_movement() -> void:
	velocity.x = move_toward(velocity.x, speed_max * direction_x, 10.0)
	
func vertical_movement() -> void:
	velocity.y = move_toward(velocity.y, (speed_max * direction_y * phase) / 2.0, 10.0)
	
func setHP(amount : float) -> void:
	super.setHP(amount)
	update_healthbar()
	
	if hp <= 0.0:
		instantiate_obj(BIG_IMPACT, global_position).scale *= 3.0
		queue_free()
		
	if phase == 1 && hp <= max_hp/1.1:
		timer_simple_bullet.wait_time = 0.45
		timer_healing_pack.wait_time = 6.0
		phase = 2

func update_healthbar() -> void:
	boss_healthbar.value = hp

func _on_timer_move_timeout() -> void:
	direction_x *= -1.0

func _on_timer_move_y_timeout() -> void:
	direction_y *= -1.0


func _on_timer_atk_timeout() -> void:
	var atk : String = NAME_ATK.pick_random()

	if atk == "simple_bullet":
		timer_simple_bullet.start()
		timer_square_bomb.stop()
	elif atk == "square_bomb":
		timer_square_bomb.start()
		timer_simple_bullet.stop()
		

func _on_timer_simple_bullet_timeout() -> void:
	atk_simple_bullet()
	
func atk_simple_bullet() -> void:
	if target != null:
		var simple_bullet : Bullet = instantiate_bullet(SIMPLE_BULLET, global_position)
		simple_bullet.setDirection((target.global_position - global_position).normalized())
		SoundManager.play_shooting_simple_bullet_sfx(0.0, -0.3)

func _on_timer_square_bomb_timeout() -> void:
	atk_square_bomb()

func atk_square_bomb() -> void:
	var nb_bomb : int = 3
	
	for i in 3:
		var square_bomb : Bullet = instantiate_bullet(SQUARE_BOMB, global_position)
		var coord : float = (nb_bomb + 2 + i) * PI / (nb_bomb + 1)
		square_bomb.setDirection( Vector2( cos(coord), sin(coord) ) )

func visibility_canva(mod : bool) -> void:
	$CanvasLayer.visible = mod


func _on_timer_healing_pack_timeout() -> void:
	if target != null:
		var healing_pack : Node2D = instantiate_obj(HEALING_PACK, global_position)
		healing_pack.speed = 50.0
		healing_pack.setDirection( (target.global_position - global_position).normalized() )

func _on_global_signal_player_dead() -> void:
	super._on_global_signal_player_dead()
	phase = 1
	timer_atk.start()
	timer_healing_pack.start()
