extends Node2D

@export var boss : Character

# GlassPlatform
@onready var glass_platform : GlassPlatform = $glass_platform
@onready var glass_platform_2 : GlassPlatform = $glass_platform2
@onready var glass_platform_3 : GlassPlatform = $glass_platform3
@onready var glass_platform_4 : GlassPlatform = $glass_platform4
@onready var fire_sprite : AnimatedSprite2D = $glass_platform2/fire_sprite

# Area that triggers the boss battle phase
@onready var area_boss : Area2D = $"../Event_triggers/area_boss_1"

# Camera attributes
@export var camera_2d : Camera2D
const LIMIT_BOT : int = -410
const LIMIT_LEFT : int = 8110
const ZOOM : float = 0.05

var player : Character = null


# Called every tick
func _process(delta: float) -> void:
	# Deals fire damage to the player if they enter a fire area
	if player != null:
		player.setHP(-delta * 7.0)

# Activates a GlassPlatform after defeating a losange mini boss
func _on_losange_enemy_mini_boss_tree_exited() -> void:
	glass_platform.activate_collision()


# Activates a GlassPlatform after reaching a key area
func _on_area_activate_platform_body_entered(body: Node2D) -> void:
	print(glass_platform_2.getActivated())
	if body != null && body.is_in_group("Player") && glass_platform_2 != null && not glass_platform_2.getActivated():
		glass_platform_2.activate_collision()
		fire_sprite.play("default")


# If the player enters a fire area, player = body and the player receives dmg every tick they stand in the fire
func _on_area_dmg_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body


# If the player exits the fire area, the player no longer loses hp from it
func _on_area_dmg_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null


# Activates the boss, GlassPlatforms and adjust the camera when the boss' room
func _on_area_boss_1_body_entered(body: Node2D) -> void:
	if body != null && body.is_in_group("Player"):
		if glass_platform_3 != null:
			# Blocks the camera to the boss' room
			tween_camera_boss()
			
			SoundManager.play_music(SoundManager.BOSS_1_OST, true)
			
			# Activates the boss
			boss.visible = true
			boss.visibility_canva(true)
			boss.process_mode = Node.PROCESS_MODE_INHERIT
			
			glass_platform_3.activate_collision()
		
		if glass_platform_4 != null:
			glass_platform_4.activate_collision()
		
		# Disables the boss' trigger area in order to prevent to adjust and activates the nodes multiple times
		area_boss.set_deferred("monitoring", false)


# Blocks and unzoom the camera to the boss' room
func tween_camera_boss() -> void:
	var new_tween : Tween = create_tween()
	var duration : float = 1.0
	new_tween.set_parallel(true)
	
	new_tween.tween_property(camera_2d, "limit_bottom", LIMIT_BOT, duration)
	new_tween.tween_property(camera_2d, "limit_left", LIMIT_LEFT, duration)
	new_tween.tween_property(camera_2d, "zoom", camera_2d.zoom - Vector2(ZOOM, ZOOM), duration)
