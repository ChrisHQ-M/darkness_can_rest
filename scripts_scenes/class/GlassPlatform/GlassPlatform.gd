class_name GlassPlatform
extends StaticBody2D

@export var height : float = 0.0
@export var direction : Vector2
@export var speed : float

@onready var glass_platform_collision : CollisionShape2D = $glass_platform_collision

var activated : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	glass_platform_collision.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if activated:
		global_position += direction * delta * speed
		
		height -= delta
		if height <= 0.0:
			activated = false

func activate_collision() -> void:
	visible = true
	glass_platform_collision.set_deferred("disabled", false)
	activated = true

func getActivated() -> bool:
	return activated
