extends Character

# Player's sprites
@onready var sprite_aura : AnimatedSprite2D = $sprite_aura
@onready var sprite_body : AnimatedSprite2D = $sprite_aura/sprite_body

# Player's jump attributes
var nb_max_jump : int = 1
var nb_jump : int = 0

# Player's health related attributes
@onready var player_healthbar : TextureProgressBar = $CanvasLayer/heart_icon/player_healthbar
var coef : float
var scaleMAX : float

# Player's attack attributes
const SIMPLE_BULLET : PackedScene = preload("res://scripts_scenes/bullet/simple_bullet/simple_bullet.tscn")
var is_attacking : bool = false
var time_holding : float = 0.0
const MAX_TIME_HOLDING : float = 10.0
var dmg_bonus : float = 1.0

# Checkpoints to save the player's progress when they die
var checkpoints_list : Array[Marker2D] = []
var chkpt_advance : int = -1

# Called when enter the node for the first time
func _ready() -> void:
	super._ready()
	
	# Configuration of the player's healthbar and the player's scale
	player_healthbar.max_value = max_hp
	player_healthbar.value = hp
	scaleMAX = scale.x
	coef = scaleMAX/max_hp
	
	sprite_body.play("idle")
	sprite_aura.play("default")

# Called every tick. Manages the player's physics system
func _physics_process(delta: float) -> void:
	horizontal_movement()
	vertical_movement(delta)
	move_and_slide()
	
	attack(delta)
	setHP(-delta*1.25)

# Manages the player's movement on the x axis
func horizontal_movement() -> void:
	var direction_x : float = Input.get_axis("left", "right")
	var acceleration : float = speed_max / 10.0
	
	if direction_x > 0.0: # direction = right
		velocity.x = move_toward(velocity.x, speed_max * direction_x, acceleration)
		sprite_aura.flip_h = true
	elif direction_x < 0.0:  # direction = left
		velocity.x = move_toward(velocity.x, speed_max * direction_x, acceleration)
		sprite_aura.flip_h = false
	else: # player's not moving
		velocity.x = move_toward(velocity.x, 0.0, acceleration)

# Manages the player's movement on the y axis
func vertical_movement(delta : float) -> void:
	if not is_on_floor():
		# In case of extra jumps like double jump, etc
		if Input.is_action_just_pressed("up") && nb_jump < nb_max_jump:
			SoundManager.play_jump_sfx(-4.0, 0.0 + nb_jump/3.0)
			tween_jump(0.1, 0.3, 0.1)
			velocity.y = jump_velocity
			nb_jump += 1
		
		if velocity.y < 0.0: # When the player rises
			velocity.y += gravity * delta
		else: # When the player is falling
			var fall_multiplier : float = 1.2
			
			if Input.is_action_pressed("down"): # Makes the player fall faster
				fall_multiplier = 5.0
				
			velocity.y += gravity * delta * fall_multiplier
	else:
		nb_jump = 0 # When the player touches the ground, the jump count resets
		if Input.is_action_just_pressed("up") && nb_jump < nb_max_jump:
			SoundManager.play_jump_sfx(-4.0, 0.0 + nb_jump/3.0)
			tween_jump(0.1, 0.3, 0.1)
			velocity.y = jump_velocity
			nb_jump += 1
			
	if Input.is_action_just_released("up") && velocity.y < 0.0: # Releasing up button makes the player jump shorter
		velocity.y *= 0.5

# Tween animation to change the player's scale when jumping
func tween_jump(scale_x : float, scale_y : float, duration : float) -> void:
	var new_tween : Tween = create_tween()
	
	var sclx : float = scale.x
	var scly : float = scale.y

	# In order : extends scale horizontally ; normal ; extends scale vertically ; normal
	new_tween.tween_property(self, "scale", Vector2(sclx, scly) - Vector2(scale_x, scale_y), duration)
	new_tween.tween_property(self, "scale", Vector2(sclx, scly), duration)
	new_tween.tween_property(self, "scale", Vector2(sclx, scly) + Vector2(scale_x, scale_y), duration)
	new_tween.tween_property(self, "scale", Vector2(sclx, scly), duration)
	
# Manages the player's HPs. If hp <= 0.0, the player is teleported to the previous checkpoint
func setHP(amount : float) -> void:
	super.setHP(amount)
	
	if hp <= 0.0:
		TransitionEffects.transition_purple()
		await TransitionEffects.transition_finished
		
		GlobalSignals.player_dead.emit()
		teleportToCheckpoint()
	
	update_healthbar()
	
# Update the visuals of the player's healthbar
func update_healthbar() -> void:
	player_healthbar.value = hp
	scale = Vector2(hp, hp) * coef

# Attack system. The player can charge their attack or not. The longer they charge, greater are the damages.
func attack(delta : float) -> void:
	# The player's holding the attack button
	if Input.is_action_pressed("attack") && time_holding < MAX_TIME_HOLDING:
		var amount : float = delta * 2.0 * (max(1.0, dmg_bonus/2.0))
		time_holding += amount
		setHP(-amount)
		
	# The player's just released the attack button, which instantiates a bullet based on the time they held
	if Input.is_action_just_released("attack"):
		var simple_bullet : Bullet = instantiate_bullet(SIMPLE_BULLET, global_position)
		simple_bullet.setDirection((get_global_mouse_position() - global_position).normalized())
		simple_bullet.setMultiplier(time_holding * dmg_bonus)
		
		SoundManager.play_shooting_simple_bullet_sfx(0.0, 0.0)
		time_holding = 0.0

# Increases the player's damage
func addDMGbonus(amount : float) -> void:
	dmg_bonus += amount

# Increases the player's health
func addMAXhp(amount : float) -> void:
	max_hp += amount
	
	# Adapts the player's HPs visuals based on their new max_hp
	player_healthbar.max_value = max_hp 
	coef = scaleMAX/max_hp
	
	setHP(amount)

# Increases the player's amount of jump
func addMAXjump(amount : int) -> void:
	nb_max_jump += amount

# Adds a new checkpoint in the player's checkpoint_list. Returns true if it added, otherwise false
func addCheckPointList(chkpt : Marker2D) -> bool:
	if chkpt not in checkpoints_list:
		checkpoints_list.append(chkpt)
		return true
		
	return false

# Moves the pointer of the checkpoints_list to checkpoints_list[val]. Returns true if it's negative or not out of bounds, otherwise false
func setCheckPointAdvance(val : int) -> bool:
	if val < len(checkpoints_list):
		chkpt_advance = val
		return true
		
	return false

# Teleports the player to the checkpoints_list[chkpt_advance] position. Restores the player's hp
func teleportToCheckpoint() -> void:
	if chkpt_advance >= 0 && chkpt_advance < len(checkpoints_list):
		hp = max_hp
		update_healthbar()
		global_position = checkpoints_list[chkpt_advance].global_position
