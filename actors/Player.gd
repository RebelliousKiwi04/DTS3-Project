extends KinematicBody2D
class_name Player

signal playerBulletFired(bullet, position, direction)

export (PackedScene) var bullet
export (int) var speed = 100

var health := 100

onready var end_of_gun = $EndOfGun
onready var gun_dir = $GunDirection
onready var attackCooldown = $AttackCooldown
onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	pass

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
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		if attackCooldown.is_stopped():
			shoot()
			attackCooldown.start()


func shoot() -> void:
	var bullet_instance = bullet.instance()
	var direction = (gun_dir.global_position-end_of_gun.global_position).normalized()
	emit_signal("playerBulletFired", bullet_instance, end_of_gun.global_position, direction)
	animationPlayer.play("MuzzleFlash")

#May be redundant, but will keep in case collectible items are added later
func _on_AttackCooldown_timeout():
	attackCooldown.stop()
	
	
func handle_hit():
	health-=20
	print("player hit", health)
	
