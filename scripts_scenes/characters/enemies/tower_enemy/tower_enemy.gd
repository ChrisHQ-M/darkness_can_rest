extends Character

const ENEMY_SIMPLE_BULLET : PackedScene = preload("res://scripts_scenes/bullet/enemy_simple_bullet/enemy_simple_bullet.tscn")

var target : Character = null
@onready var timer_fire_rate : Timer = $TimerFireRate

func _on_range_atk_area_body_entered(body: Node2D) -> void:
	if body != null && body.is_in_group("Player") && body is Character:
		target = body
		timer_fire_rate.start()

func _on_range_atk_area_body_exited(body: Node2D) -> void:
	if body != null && body.is_in_group("Player") && body is Character:
		target = null
		timer_fire_rate.stop()


func _on_timer_fire_rate_timeout() -> void:
	if target != null:
		var bullet : Bullet = instantiate_bullet(ENEMY_SIMPLE_BULLET, global_position)
		bullet.setDirection((target.global_position - global_position).normalized())
