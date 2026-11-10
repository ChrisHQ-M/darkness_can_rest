extends CharacterEnemy

# Boss' sprites and interface
@onready var boss_sprite : AnimatedSprite2D = $boss_1_sprite
@onready var boss_healthbar : TextureProgressBar = $CanvasLayer/heart_icon/boss_healthbar
@onready var canvas_layer : CanvasLayer = $CanvasLayer

# Boss' movements attributes
@onready var timer_move_x : Timer = $TimerMoveX
@onready var timer_move_y : Timer = $TimerMoveY
var direction_x : float = -1.0
var direction_y : float = 1.0

# Boss' attacks attributes
@export var target : Character
const SIMPLE_BULLET : PackedScene = preload("res://scripts_scenes/bullet/enemy_simple_bullet/enemy_simple_bullet.tscn")
const SQUARE_BOMB : PackedScene = preload("res://scripts_scenes/bullet/enemy_square_bullet/enemy_square_bomb.tscn")
@onready var timer_atk : Timer = $TimerATK
const NAME_ATK : Array[String] = ["simple_bullet", "square_bomb"]
@onready var timer_simple_bullet : Timer = $TimerSimpleBullet
@onready var timer_square_bomb : Timer = $TimerSquareBomb

# Healing pack
const HEALING_PACK : PackedScene = preload("res://scripts_scenes/pickable/healing_pack/healing_pack.tscn")
@onready var timer_healing_pack : Timer = $TimerHealingPack

# Boss' phase (changed when the boss is below a certain amount of hp set in setHP(float)
var phase : int = 1

# Called when enter the node for the first time
func _ready() -> void:
	super._ready()
	boss_sprite.play("default")
	
	# Updates boss' health
	boss_healthbar.max_value = max_hp
	update_healthbar()
	
	# Starts all timers
	timer_move_x.start()
	timer_move_y.start()
	timer_atk.start()
	timer_healing_pack.start()
	

# Called every tick, manages the boss' movements
func _physics_process(_delta: float) -> void:
	horizontal_movement()
	vertical_movement()
	move_and_slide()
	
	
# Method to manage the boss' movements on the horizontal axis
func horizontal_movement() -> void:
	velocity.x = move_toward(velocity.x, speed_max * direction_x, 10.0)
	
	
# Method to manage the boss' movements on the vertical axis. Speed up when changes phase
func vertical_movement() -> void:
	velocity.y = move_toward(velocity.y, (speed_max * direction_y * phase) / 2.0, 10.0)
	
	
# Manages boss' hp, enter phase 2 when hp <= max_hp / 2.0
func setHP(amount : float) -> void:
	var new_hp : float = hp + amount
	
	if new_hp < 0.0:
		hp = 0.0
	elif new_hp > max_hp:
		hp = max_hp
	else:
		hp = new_hp

	update_healthbar()
	
	if hp <= 0.0:
		instantiate_obj(BIG_IMPACT, global_position).scale *= 3.0
		queue_free()
		
	if phase == 1 && hp <= max_hp / 2.0:
		timer_simple_bullet.wait_time = 0.45
		timer_healing_pack.wait_time = 7.5
		phase = 2


# Updates the healthbar interface based on boss' hp
func update_healthbar() -> void:
	boss_healthbar.value = hp


# Every timeout, changes the horizontal direction (left or right)
func _on_timer_move_timeout() -> void:
	direction_x *= -1.0


# Every timeout, changes the vertical direction (up or down)
func _on_timer_move_y_timeout() -> void:
	direction_y *= -1.0


# Method to manage the boss' attacks. Every timeout, pick a random attack from the array NAME_ATK.
func _on_timer_atk_timeout() -> void:
	var atk : String = NAME_ATK.pick_random()

	# Attack based upon the random atk name picked. Stops all the timers that are not related to the attack
	if atk == "simple_bullet":
		timer_simple_bullet.start()
		timer_square_bomb.stop()
	elif atk == "square_bomb":
		timer_square_bomb.start()
		timer_simple_bullet.stop()
		

# Shoots a simple bullet towards the player every timeout
func _on_timer_simple_bullet_timeout() -> void:
	atk_simple_bullet()

# Instantiate a Bullet towards the player
func atk_simple_bullet() -> void:
	if target != null:
		var simple_bullet : Bullet = instantiate_bullet(SIMPLE_BULLET, global_position)
		simple_bullet.setDirection((target.global_position - global_position).normalized())
		
		SoundManager.play_shooting_simple_bullet_sfx(0.0, -0.3)


# Shoots a square bomb towards the player every timeout
func _on_timer_square_bomb_timeout() -> void:
	atk_square_bomb()

# Instantiate nb_bomb with a direction determined with trigonometry
func atk_square_bomb() -> void:
	var nb_bomb : int = 3
	
	for i in 3:
		var square_bomb : Bullet = instantiate_bullet(SQUARE_BOMB, global_position)
		var coord : float = (nb_bomb + 2 + i) * PI / (nb_bomb + 1)
		square_bomb.setDirection( Vector2( cos(coord), sin(coord) ) )


# Changes the canvas_layer visibility to mod (true or false)
func visibility_canva(mod : bool) -> void:
	canvas_layer.visible = mod


# Shoots (Instantiates) a healing_pack towards the player every timeout
func _on_timer_healing_pack_timeout() -> void:
	if target != null:
		var healing_pack : Node2D = instantiate_obj(HEALING_PACK, global_position)
		healing_pack.speed = 50.0
		healing_pack.setDirection( (target.global_position - global_position).normalized() )


# If the player dies, resets the boss' phase to 1, restores hp and timers
func _on_global_signal_player_dead() -> void:
	super._on_global_signal_player_dead()
	phase = 1
	timer_atk.start()
	timer_healing_pack.start()
	update_healthbar()


# Deals body dmg if enters in collision with the player's hitbox
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area != null && area.is_in_group("Player"):
		var body : Character = area.get_parent()
		body.setHP(-body_dmg)
		
		instantiate_obj(BIG_IMPACT, body.global_position)
		SoundManager.play_hit_sfx(-5.0, 0.0)
		GlobalSignals.engine_slow.emit(0.35, 0.1)
