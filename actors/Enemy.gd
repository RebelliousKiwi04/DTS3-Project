extends KinematicBody2D
#Enemy Class identifier
class_name Enemy

#Enemy death signal
signal enemyDied

#Onready vars to handle nodes
onready var enemyHealth = $HealthHandler
onready var ai = $AIHandler
onready var weapon = $Weapon
onready var collision_shape = $CollisionShape2D
onready var HuntTimer = $HuntTimer


export (int) var speed = 75


func _ready():
	#Dependency injection was easiest for this, didn;t want to rely on tree
	ai.initialize(self, weapon)

#Initialise AI hunting
func begin_hunt():
	if ai.current_state != ai.State.ENGAGE:
		ai.set_state(ai.State.HUNT)
		HuntTimer.start()
	
#Handle bullet hits
func handle_hit():
	enemyHealth.health-=20
	if enemyHealth.health <=0:
		emit_signal("enemyDied")
		queue_free()

#Wrapper around lerp function to rotate actor towards a location
func rotate_towards(location):
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)

#Wrapper to return velocity towards a location
func velocity_towards(location):
	return global_position.direction_to(location)*speed

#Sets AI state to patrol on timeout
func _on_HuntTimer_timeout():
	if ai.current_state != ai.State.ENGAGE:
		ai.set_state(ai.State.PATROL)
