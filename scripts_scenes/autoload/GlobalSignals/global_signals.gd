extends Node

signal player_dead # Emit when the player' hp reaches 0.0 or below

signal camera_shake # Shakes the camera

signal engine_slow # Slows the time engine

func _ready() -> void:
	engine_slow.connect(_on_engine_slow)

func _on_engine_slow(intensity : float, duration : float) -> void:
	Engine.time_scale = intensity
	await get_tree().create_timer(duration).timeout
	Engine.time_scale = 1.0
