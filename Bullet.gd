extends Area2D
class_name Bullet

export (int) var speed = 1

var direction := Vector2.ZERO

func _physics_process(delta) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction*speed

		global_position+=velocity/2

func set_dir(dir: Vector2) -> void:
	self.direction = dir
	rotation+= direction.angle()


func _on_BulletLifespan_timeout():
	queue_free()
