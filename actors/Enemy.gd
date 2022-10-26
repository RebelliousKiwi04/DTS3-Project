extends KinematicBody2D

onready var enemyHealth = $HealthHandler

func handle_hit():
	enemyHealth.health-=20
	print("Enemy Hit!", enemyHealth.health)
	if enemyHealth.health <=0:
		queue_free()
