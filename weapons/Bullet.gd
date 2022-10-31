extends Area2D
#Bullet class
class_name Bullet

export (int) var speed = 1

var direction := Vector2.ZERO

#Bullet movement
func _physics_process(delta) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction*speed

		global_position+=velocity/2

#Set bullet direction
func set_dir(dir: Vector2) -> void:
	self.direction = dir
	rotation+= direction.angle()

#Delete bullet
func _on_BulletLifespan_timeout():
	queue_free()

#Bullet collision handling
func _on_Bullet_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
	queue_free()
