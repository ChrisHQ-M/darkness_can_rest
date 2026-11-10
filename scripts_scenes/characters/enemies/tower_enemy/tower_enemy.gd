extends CharacterEnemy

# Bullet to instantiate
const ENEMY_SIMPLE_BULLET : PackedScene = preload("res://scripts_scenes/bullet/enemy_simple_bullet/enemy_simple_bullet.tscn")

# Target to shoot at
var target : Character = null
@onready var timer_fire_rate : Timer = $TimerFireRate

# Tower's sprite
@onready var tower_sprite : AnimatedSprite2D = $tower_sprite

@export var fire_rate : float = 0.6

# Called when enter the tree for the first time
func _ready() -> void:
	super._ready()
	timer_fire_rate.wait_time = fire_rate
	tower_sprite.play("idle")


# If the player is within range, they become a target to shoot at
func _on_range_atk_area_body_entered(body: Node2D) -> void:
	if body != null && body.is_in_group("Player") && body is Character:
		target = body
		timer_fire_rate.start()


# If the player is out of range, the tower no longer shoots and target = null
func _on_range_atk_area_body_exited(body: Node2D) -> void:
	if body != null && body.is_in_group("Player") && body is Character:
		target = null
		timer_fire_rate.stop()


# Every timeout, the tower shoots the bullet if it has a target not null
func _on_timer_fire_rate_timeout() -> void:
	if target != null:
		var bullet : Bullet = instantiate_bullet(ENEMY_SIMPLE_BULLET, global_position)
		bullet.setDirection((target.global_position - global_position).normalized())
