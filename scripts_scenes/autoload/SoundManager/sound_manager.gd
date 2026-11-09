extends Node

@onready var music : AudioStreamPlayer = $AudioMusic

const MAIN_MENU_OST : AudioStream = preload("res://sounds/music/shrine.mp3")
const MAIN_FIELD_OST : AudioStream = preload("res://sounds/music/shrine_field_theme.mp3")
const BOSS_1_OST : AudioStream = preload("res://sounds/music/shrine_boss.mp3")

const CLICK_SFX : AudioStream = preload("res://sounds/sfx/click_sfx/click_sfx.ogg")
const JUMP_SFX : AudioStream = preload("res://sounds/sfx/jump_sfx/jump_sound_effect.ogg")
const HEALING_SFX : AudioStream = preload("res://sounds/sfx/healing_sfx/healing_sfx.ogg")
const CHARGED_BULLET_SFX : AudioStream = preload("res://sounds/sfx/shoot_sfx/hitting_charge_bullet_sound.wav")
const SHOOTING_SIMPLE_BULLET_SFX : AudioStream = preload("res://sounds/sfx/shoot_sfx/shooting_simple_bullet.wav")

# Plays one music in the node's stream "AudioMusic" with a loop option and returns the node.
func play_music(stream : AudioStream, loop : bool) -> AudioStreamPlayer:
	if music.stream == stream:
		return
	
	# Configurations of the music node
	music.stream = stream
	music.stream.loop = loop
	music.bus = "Music"
	music.play()
	
	return music

# Create an AudioStreamPlayer that frees after playing a SFX. Can change the volume_db and pitch_scale and returns the node.
func play_sfx(stream : AudioStream, vol_db : float, pitch_scale : float) -> AudioStreamPlayer:
	var new_sfx : AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(new_sfx)
	
	# Configurations of the SFX node
	if stream != null:
		new_sfx.stream = stream
		new_sfx.volume_db += vol_db
		new_sfx.pitch_scale += pitch_scale
		new_sfx.bus = "SFX"
		new_sfx.play()
	
	return new_sfx

func play_click_sfx(vol_db : float, pitch_scale : float) -> AudioStreamPlayer:
	return play_sfx(CLICK_SFX, vol_db, pitch_scale)

func play_jump_sfx(vol_db : float, pitch_scale : float) -> AudioStreamPlayer:
	return play_sfx(JUMP_SFX, vol_db, pitch_scale)
	
func play_healing_sfx(vol_db : float, pitch_scale : float) -> AudioStreamPlayer:
	return play_sfx(HEALING_SFX, vol_db, pitch_scale)

func play_charged_sfx(vol_db : float, pitch_scale : float) -> AudioStreamPlayer:
	return play_sfx(CHARGED_BULLET_SFX, vol_db, pitch_scale)

func play_shooting_simple_bullet_sfx(vol_db : float, pitch_scale : float) -> AudioStreamPlayer:
	return play_sfx(SHOOTING_SIMPLE_BULLET_SFX, vol_db, pitch_scale)
