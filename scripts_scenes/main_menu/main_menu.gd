extends Control

var has_clicked : bool = false # Prevents multiple transitions (thus "await") happening

@onready var camera_2D : Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_music(SoundManager.MAIN_MENU_OST, true)


func _on_play_btn_pressed() -> void:
	if has_clicked == false:
		has_clicked = true
		
		tween_camera()
		SoundManager.play_click_sfx(-5.0, 0.0)
		
		TransitionEffects.transition_purple()
		await TransitionEffects.transition_finished
		
		get_tree().change_scene_to_file("res://scripts_scenes/intro_scene/intro_scene.tscn")


# Camera zoom out then zoom in
func tween_camera() -> void:
	var new_tween : Tween = create_tween()
	
	var zoom_out : float = 0.4
	var duration_out : float = 0.1
	
	var zoom_in : float = 1.0
	var duration_in : float = 0.3
	
	new_tween.tween_property(camera_2D, "zoom", Vector2(1.0 - zoom_out, 1.0 - zoom_out), duration_out)
	new_tween.tween_property(camera_2D, "zoom", Vector2(1.0 + zoom_in, 1.0 + zoom_in), duration_in)
