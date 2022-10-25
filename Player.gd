extends KinematicBody2D

export (PackedScene) var bullet
export (int) var speed = 100

onready var end_of_gun = $EndOfGun

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
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
		shoot()


func shoot() -> void:
	var bullet_instance = bullet.instance()
	get_tree().get_root().add_child(bullet_instance)
	bullet_instance.global_position = end_of_gun.global_position
	var target = get_global_mouse_position()
	var direction_to_mouse = bullet_instance.global_position.direction_to(target).normalized()
	bullet_instance.set_dir(direction_to_mouse)
	
	
