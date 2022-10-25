extends KinematicBody2D

var health :=100

func handle_hit():
	health-=20
	print("Enemy Hit!", health)
	if health <=0:
		queue_free()
