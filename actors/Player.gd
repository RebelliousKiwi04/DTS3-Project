extends KinematicBody2D
#Player script
class_name Player

#Player signals
signal player_health_changed(new_health)
signal player_died

export (int) var speed = 100

onready var playerHealth = $HealthHandler
onready var weapon = $Weapon
onready var collision_shape = $CollisionShape2D

#Handle movement inputs and movements
func _physics_process(_delta: float) -> void:
	var movement_dir := Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		movement_dir.y = -1
	if Input.is_action_pressed("ui_down"):
		movement_dir.y = 1
	if Input.is_action_pressed("ui_left"):
		movement_dir.x = -1
	if Input.is_action_pressed("ui_right"):
		movement_dir.x = 1
	
	movement_dir = movement_dir.normalized()
	move_and_slide(movement_dir*speed)
	
	look_at(get_global_mouse_position())
	
#Handle action inputs
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		weapon.shoot()
	if event.is_action_released("reload"):
		weapon.start_reload()

#Handle player death
func die():
	emit_signal("player_died")

#Handle function for player being hit by a bullet
func handle_hit():
	playerHealth.health-=20
	if playerHealth.health <=0:
		die()
	emit_signal("player_health_changed", playerHealth.health)
	
