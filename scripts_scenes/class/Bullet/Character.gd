# Character inherits from CharacterBody2D. A Character has HPs and 2D physics system (speed, gravity...)

class_name Character
extends CharacterBody2D

# Physics attributes
@export var speed_max = 75.0
@export var jump_velocity = -400.0
@export var gravity : float = 300.0

# HPs attributes
@export var max_hp : float = 100.0
var hp : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.player_dead.connect(_on_global_signal_player_dead)
	hp = max_hp

# Manages the Character's HP. setHP adds to the HPs an amount. HP in limited to [0 ; max_hp]
func setHP(amount : float) -> void:
	var new_hp : float = hp + amount
	
	if new_hp < 0.0:
		hp = 0.0
	elif new_hp > max_hp:
		hp = max_hp
	else:
		hp = new_hp

# Instantiate a Bullet (inherits from Node2D)
func instantiate_bullet(obj : PackedScene, pos : Vector2) -> Bullet:
	var object : Bullet = instantiate_obj(obj, pos)
	return object

# Instantiate a Node2D with a global_position
func instantiate_obj(obj : PackedScene, pos : Vector2) -> Node2D:
	var object : Node2D = obj.instantiate()
	object.global_position = pos
	get_tree().current_scene.add_child(object)
	
	return object

# When the player dies, all enemies still alive get their hp restored
func _on_global_signal_player_dead() -> void:
	hp = max_hp
