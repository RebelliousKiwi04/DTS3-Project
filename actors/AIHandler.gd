extends Node2D


signal state_changed(new_state)


#Finite State Machine states
enum State {
	PATROL,
	ENGAGE
}


onready var playerDetectionZone = $PlayerDetectionZone
onready var patrolTimer = $PatrolTimer


var current_state = null setget set_state
var player: Player = null
var weapon: Weapon = null
var actor: Enemy = null
var pathfinding: pathfinding

# PATROL STATE
var origin: Vector2 = Vector2.ZERO
var patrol_location := Vector2.ZERO
var patrol_location_reached := false
var actorVelocity := Vector2.ZERO


func _physics_process(delta) -> void:
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				print("Patrol Location: ", patrol_location)
				print("Current Location: ", actor.global_position)
				actor.move_and_slide(actorVelocity)
				actor.rotate_towards(patrol_location)
				if  actor.global_position.distance_to(patrol_location) <5:
					patrol_location_reached = true
					actorVelocity = Vector2.ZERO
					patrolTimer.start()
		State.ENGAGE:
			if player != null and weapon != null:
				actor.rotate_towards(player.global_position)
				var angleToPlayer = actor.global_position.direction_to(player.global_position).angle()
				if abs(actor.rotation-angleToPlayer)< 0.1:
					weapon.shoot()
			else:
				print("Weapon or player null in engage state")
		_:
			print("Error found in enemy state, setting state to patrol", current_state)
			set_state(State.PATROL)


func initialize(actor: Enemy, weapon: Weapon):
	self.actor = actor
	self.weapon = weapon
	origin = self.actor.global_position
	set_state(State.PATROL)
	weapon.connect("weapon_out_of_ammo", self, "handle_reload")
	
func set_state(new_state: int):
	if new_state == current_state:
		return
	
	if new_state == State.PATROL:
		patrolTimer.start()
		origin = actor.global_position
		patrol_location_reached = true
		
	current_state = new_state
	emit_signal("state_changed", new_state)
	

func get_new_target():
	pass


func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body


func patrolTimer_timeout():
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	actorVelocity = actor.velocity_towards(patrol_location)


func handle_reload():
	weapon.start_reload()


func _on_PlayerEngagementZone_body_exited(body):
	if player and body == player:
		set_state(State.PATROL)
		player = null

