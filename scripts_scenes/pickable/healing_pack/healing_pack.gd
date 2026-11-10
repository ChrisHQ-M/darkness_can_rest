extends AnimatedSprite2D

const BIG_IMPACT_ANIMATION : PackedScene = preload("res://scripts_scenes/particles/big_impact/big_impact_animation.tscn")

const HEALING_AMOUNT : float = 35.0

@export var speed : float = 0.0
var direction : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("default")
	
	
func _process(delta: float) -> void:
	global_position += speed * delta * direction
	
	
# Sets the direction where the Bullet has to move
func setDirection(dir : Vector2) -> void:
	direction = dir


# Heals the player when enters in contact
func _on_pick_area_body_entered(body: Node2D) -> void:
	if body != null && body.is_in_group("Player"):
		body.setHP(HEALING_AMOUNT)
		SoundManager.play_healing_sfx(0.0, 0.0)
		
		# Instantiate impact animation
		var big_impact : AnimatedSprite2D = BIG_IMPACT_ANIMATION.instantiate()
		big_impact.global_position = global_position
		big_impact.scale *= 0.75
		get_tree().current_scene.add_child(big_impact)
		
		queue_free()
