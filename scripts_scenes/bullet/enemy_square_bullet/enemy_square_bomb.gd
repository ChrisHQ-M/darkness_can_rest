extends Bullet

const ENEMY_SQUARE_BULLET : PackedScene = preload("res://scripts_scenes/bullet/enemy_square_bullet/enemy_square_bullet.tscn")
const NB_SQUARE : int = 6

@onready var sprite : AnimatedSprite2D = $sprite_square_bomb
@onready var timer_disappear : Timer = $TimerDisappear
@onready var timer_explode : Timer = $TimerExplode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_explode.start()
	sprite.play("default")

func _process(delta: float) -> void:
	super._process(delta)
	rotation_degrees += delta * speed

func _on_timer_disappear_timeout() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	timer_disappear.start()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area != null && area.is_in_group("Player"):
		var body : Character = area.get_parent()
		body.setHP(-dmg_amount)
		SoundManager.play_hit_sfx(-5.0, 0.0)
		
		var big_impact : AnimatedSprite2D = instantiate_obj(BIG_IMPACT, global_position)
		big_impact.scale *= 0.5
		
		queue_free()


func _on_timer_explode_timeout() -> void:
	for i in NB_SQUARE:
		var square_bullet : Bullet = ENEMY_SQUARE_BULLET.instantiate()
		square_bullet.global_position = global_position
		
		var coord : float = (2 * i * PI) / NB_SQUARE
		square_bullet.setDirection( Vector2( cos(coord), sin(coord) ) )
		get_tree().current_scene.add_child(square_bullet)
	
	SoundManager.play_explosion_sfx(-20.0, 0.0)
	queue_free()
