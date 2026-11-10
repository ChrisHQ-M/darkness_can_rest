extends Camera2D

var shake_intensity : float = 0.0
var activate_shake_time : float = 0.0

var shake_decay : float = 5.0

var shake_time : float = 0.0
var shake_time_speed : float = 20.0

var noise = FastNoiseLite.new()

var delay : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.camera_shake.connect(_on_camera_shake)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delay += delta
	if activate_shake_time > 0:
		shake_time += delta * shake_time_speed
		activate_shake_time -= delta
		
		offset = Vector2(
			noise.get_noise_2d(shake_time, 0) * shake_intensity,
			noise.get_noise_2d(0, shake_time) * shake_intensity
		)
		
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5 * delta)

func _on_camera_shake(intensity : int, time : float) -> void:
	randomize()
	
	noise.seed = randi()
	noise.frequency = intensity
	
	shake_intensity = intensity
	activate_shake_time = time
	shake_time = 0.0
