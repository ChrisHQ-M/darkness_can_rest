class_name Bullet
extends Node2D

# Impact animation to instantiate
const BIG_IMPACT : PackedScene = preload("res://scripts_scenes/particles/big_impact/big_impact_animation.tscn")

# DMG and speed
@export var dmg_amount : float
@export var speed : float
var direction : Vector2

# Free the Bullet if exits the screen
@export var notifier : VisibleOnScreenNotifier2D
@export var timer_disappear : Timer


# Called when enter the node for the first time
func _ready() -> void:
	notifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	timer_disappear.timeout.connect(_on_timer_disappear_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	global_position += speed * delta * direction


# Sets the direction where the Bullet has to move
func setDirection(dir : Vector2) -> void:
	direction = dir


# Instantiate an obj at a global_position pos and adds this Node2D to the scene. Returns the Node2D
func instantiate_obj(obj : PackedScene, pos : Vector2) -> Node2D:
	var object : Node2D = obj.instantiate()
	object.global_position = pos
	get_tree().current_scene.add_child(object)
	
	return object


# Seconds after exiting the screen, the Bullet is freed
func _on_timer_disappear_timeout() -> void:
	queue_free()


# Starts a timer to free the Bullet when the Bullet exits the screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	timer_disappear.start()
