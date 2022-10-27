extends Node2D
class_name Weapon


export (PackedScene) var bullet


onready var end_of_gun = $EndOfGun
onready var gun_dir = $GunDirection
onready var attackCooldown = $AttackCooldown
onready var animationPlayer = $AnimationPlayer


func shoot() -> void:
	if attackCooldown.is_stopped():
		var bullet_instance = bullet.instance()
		var direction = (gun_dir.global_position-end_of_gun.global_position).normalized()
		globals.emit_signal("bullet_fired", bullet_instance, end_of_gun.global_position, direction)
		animationPlayer.play("MuzzleFlash")
		attackCooldown.start()
		
		
#May be redundant, but will keep in case collectible items are added later
func _on_AttackCooldown_timeout():
	attackCooldown.stop()
