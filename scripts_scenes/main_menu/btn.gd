extends TextureButton

const SCALE_STANDARD : float = 1.0 # Default scale
const SCALE_ZOOM : float = 0.2 # Default scale +- SCALE_ZOOM
const DURATION : float = 0.15 # Duration of tween

# Increases the scale for a duration of DURATION then decreases it to its standard scale
func tween_button_scale() -> void:
	var new_tween : Tween = create_tween()
	
	new_tween.tween_property(self, "scale", Vector2(SCALE_STANDARD + SCALE_ZOOM, SCALE_STANDARD + SCALE_ZOOM), DURATION)
	new_tween.tween_property(self, "scale", Vector2(SCALE_STANDARD, SCALE_STANDARD), DURATION)

func _on_mouse_entered() -> void:
	tween_button_scale()

func _on_pressed() -> void:
	tween_button_scale()
