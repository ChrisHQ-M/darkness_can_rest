extends Control

# Boss and player nodes
@export var boss : Character 
@export var player : Character

# Node2D that contains all the map's checkpoints
@onready var checkpoints : Node2D = $Checkpoints


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_music(SoundManager.MAIN_FIELD_OST, true)

	# Disable the boss until it gets activated
	boss.visible = false
	boss.visibility_canva(false)
	boss.process_mode = Node.PROCESS_MODE_DISABLED
	
	
	# Adds all the checkpoints to the player's checkpoints_list
	var checkpoints_list : Array[Node] = checkpoints.get_children()
	for chkpt in checkpoints_list:
		if chkpt is Marker2D:
			player.addCheckPointList(chkpt)
	player.setCheckPointAdvance(0 if not checkpoints_list.is_empty() else -1)


# When the boss is defeated, go to the end_screen
func _on_boss_1_tree_exited() -> void:
	TransitionEffects.transition_purple()
	await TransitionEffects.transition_finished
	
	get_tree().change_scene_to_file("res://scripts_scenes/end_screen/end_screen.tscn")


# Changes the player's chkpt_advance
func _on_chkpt_1_body_entered(body: Node2D) -> void:
	if body != null && body.is_in_group("Player"):
		player.setCheckPointAdvance(1)


# Changes the player's chkpt_advance
func _on_chkpt_2_body_entered(body: Node2D) -> void:
	if body != null && body.is_in_group("Player"):
		player.setCheckPointAdvance(2)


# Changes the player's chkpt_advance
func _on_chkpt_3_body_entered(body: Node2D) -> void:
	if body != null && body.is_in_group("Player"):
		player.setCheckPointAdvance(3)
