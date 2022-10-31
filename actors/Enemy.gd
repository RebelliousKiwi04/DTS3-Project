extends KinematicBody2D
class_name Enemy

signal enemyDied

onready var enemyHealth = $HealthHandler
onready var ai = $AIHandler
onready var weapon = $Weapon
onready var collision_shape = $CollisionShape2D
onready var HuntTimer = $HuntTimer


export (int) var speed = 75


func _ready():
	#Dependency injection was easiest for this, didn;t want to rely on tree
	ai.initialize(self, weapon)

	
func begin_hunt():
	if str(ai.State) != str(ai.State.ENGAGE):
		ai.set_state(ai.State.HUNT)
		HuntTimer.start()
	
func handle_hit():
	enemyHealth.health-=20
	print("Enemy Hit!", enemyHealth.health)
	if enemyHealth.health <=0:
		emit_signal("enemyDied")
		queue_free()


func rotate_towards(location):
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)


func velocity_towards(location):
	return global_position.direction_to(location)*speed


func _on_HuntTimer_timeout():
	if str(ai.State) != str(ai.State.ENGAGE):
		ai.set_state(ai.State.PATROL)
