extends Node2D
#Weapon class
class_name Weapon

#Weapon related signals
signal weapon_out_of_ammo
signal ammo_values_changed(ammo, new_max_ammo)

export (PackedScene) var bullet


var max_ammo: int =10
var current_ammo: int = max_ammo


onready var end_of_gun = $EndOfGun
onready var gun_dir = $GunDirection
onready var attackCooldown = $AttackCooldown
onready var animationPlayer = $AnimationPlayer

#Shoot function to emit bullet firing signal, and instance bullet
func shoot() -> void:
	if current_ammo != 0 and attackCooldown.is_stopped():
		var bullet_instance = bullet.instance()
		var direction = (gun_dir.global_position-end_of_gun.global_position).normalized()
		globals.emit_signal("bullet_fired", bullet_instance, end_of_gun.global_position, direction)
		animationPlayer.play("MuzzleFlash")
		attackCooldown.start()
		current_ammo-=1
		emit_signal("ammo_values_changed", current_ammo, max_ammo)
		if current_ammo == 0:
			emit_signal("weapon_out_of_ammo")
	
#Start reload function
func start_reload():
	animationPlayer.play("reload")
	
#Stop reload, and adjust current ammo
func _stop_reload():
	current_ammo = max_ammo
	emit_signal("ammo_values_changed", current_ammo, max_ammo)
		
#May be redundant, but will keep in case collectible items are added later
func _on_AttackCooldown_timeout():
	attackCooldown.stop()
