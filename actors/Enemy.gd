extends KinematicBody2D
class_name Enemy

onready var enemyHealth = $HealthHandler
onready var ai = $AIHandler
onready var weapon = $Weapon
onready var collision_shape = $CollisionShape2D

export (int) var speed = 75


func _ready():
	#Dependency injection was easiest for this, didn;t want to rely on tree
	ai.initialize(self, weapon)


func handle_hit():
	enemyHealth.health-=20
	print("Enemy Hit!", enemyHealth.health)
	if enemyHealth.health <=0:
		queue_free()


func rotate_towards(location):
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)


func velocity_towards(location):
	return global_position.direction_to(location)*speed
