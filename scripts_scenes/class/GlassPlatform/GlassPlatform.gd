class_name GlassPlatform
extends StaticBody2D

@export var can_reset : bool

var init_position : Vector2

# Movements attributes
@export var init_height : float = 0.0
var distance_height : float = 0.0
@export var direction : Vector2
@export var speed : float

@onready var glass_platform_collision : CollisionShape2D = $glass_platform_collision

var activated : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if can_reset:
		GlobalSignals.player_dead.connect(_on_player_dead)
	
	visible = false
	glass_platform_collision.disabled = true
	
	distance_height = init_height
	init_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if activated:
		global_position += direction * delta * speed
		
		distance_height -= delta
		if distance_height <= 0.0: # When reached its end, disactivates and stops moving
			activated = false


# Moves, activates the GlassPlatform
func activate_collision() -> void:
	visible = true
	glass_platform_collision.set_deferred("disabled", false)
	activated = true


# Returns the boolean activated
func getActivated() -> bool:
	return activated


func _on_player_dead() -> void:
	global_position = init_position
	visible = false
	glass_platform_collision.set_deferred("disabled", true)
	activated = false
	distance_height = init_height
