extends Area2D


export (int) var speed = 150

var direction := Vector2.ZERO

func _physics_process(delta) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction*speed
		global_position+=velocity

func set_dir(dir: Vector2) -> void:
	self.direction = dir
