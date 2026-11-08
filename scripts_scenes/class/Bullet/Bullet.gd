class_name Bullet
extends Node2D

const BIG_IMPACT : PackedScene = preload("res://scripts_scenes/particles/big_impact/big_impact_animation.tscn")

@export var dmg_amount : float
@export var speed : float
var direction : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += speed * delta * direction

func setDirection(dir : Vector2) -> void:
	direction = dir

func instantiate_obj(obj : PackedScene, pos : Vector2) -> Node2D:
	var object : Node2D = obj.instantiate()
	object.global_position = pos
	get_tree().current_scene.add_child(object)
	
	return object
