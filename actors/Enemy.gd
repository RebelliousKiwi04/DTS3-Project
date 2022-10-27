extends KinematicBody2D
class_name Enemy

onready var enemyHealth = $HealthHandler
onready var ai = $AIHandler
onready var weapon = $Weapon


func _ready():
	#Dependency injection was easiest for this, didn;t want to rely on tree
	ai.initialize(self, weapon)


func handle_hit():
	enemyHealth.health-=20
	print("Enemy Hit!", enemyHealth.health)
	if enemyHealth.health <=0:
		queue_free()
