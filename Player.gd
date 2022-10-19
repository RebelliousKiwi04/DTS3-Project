extends KinematicBody2D


export (int) var speed = 100


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
	

#func _unhandled_input(event: InputEvent) -> void:
#	pass
