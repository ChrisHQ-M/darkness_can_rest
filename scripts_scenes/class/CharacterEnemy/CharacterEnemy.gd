class_name CharacterEnemy
extends Character

# Impact animation to instantiate
const BIG_IMPACT : PackedScene = preload("res://scripts_scenes/particles/big_impact/big_impact_animation.tscn")

@export var body_dmg : float

# Manages the hp, if hp <= 0.0, free the Character
func setHP(amount : float) -> void:
	super.setHP(amount)
	
	if hp <= 0.0:
		queue_free()
