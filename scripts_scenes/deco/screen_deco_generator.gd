extends CanvasLayer

var deco_star : PackedScene = preload("res://scripts_scenes/deco/star/deco_star.tscn")

@onready var timer_deco_star : Timer = $TimerSpawnDecoStar

# Called when enter the node for the first time.
func _ready() -> void:
	timer_deco_star.start()

# Method to instantiate an AnimtedSprite2D node
func instantiate_animated_sprite_2d(obj : PackedScene) -> AnimatedSprite2D:
	var object : AnimatedSprite2D = obj.instantiate()
	
	var viewport_size : Vector2 = get_viewport().size
	object.position = Vector2(randf() * viewport_size.x, randf() * viewport_size.y)
	
	get_tree().current_scene.add_child(object)
	
	return object

# Spawns a deco_star every timer's timeout
func _on_timer_spawn_deco_star_timeout() -> void:
	var star : AnimatedSprite2D = instantiate_animated_sprite_2d(deco_star)
	
	# Randomize the star's scale
	var scale_range_x : float = randf() * 0.4 + 0.8
	var scale_range_y : float = randf() * 0.4 + 0.8
	star.scale = Vector2(scale_range_x, scale_range_y)
	
	star.rotation_degrees = randf() * 320.0
	
	timer_deco_star.wait_time = randf() * 0.2
