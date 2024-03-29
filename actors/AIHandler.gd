extends Node2D


signal state_changed(new_state)


#Finite State Machine states
enum State {
	PATROL,
	ENGAGE,
	HUNT
}


onready var playerDetectionZone = $PlayerDetectionZone
onready var patrolTimer = $PatrolTimer


var current_state = null setget set_state
var player: Player = null
var weapon: Weapon = null
var actor: Enemy = null
var pathfinding: pathfinding

#HUNT STATE
var enemy_pos_reached = false
var enemy_pos = null

# PATROL STATE
var origin: Vector2 = Vector2.ZERO
var patrol_location := Vector2.ZERO
var patrol_location_reached := false
var actorVelocity := Vector2.ZERO

#Variable to smooth out Hunt state transitions
var player_in_body =false


func _physics_process(delta) -> void:
	#Effectively the same as a switch statement, handles AI 
	match current_state:
		#If state is patrol
		State.PATROL:
			#If location isn't reached, then get path, and move towards it
			if not patrol_location_reached:
				var path = pathfinding.get_new_path(global_position, patrol_location)

				if path.size()>1:
					if actor.global_position.distance_to(patrol_location) <50:
						patrol_location_reached = true
					actorVelocity = actor.velocity_towards(path[1])
					actor.rotate_towards(path[1])
					actor.move_and_slide(actorVelocity)

				else:
					patrol_location_reached = true
					actorVelocity = Vector2.ZERO
					patrolTimer.start()
		#Hunt state
		State.HUNT:
			#If enemy hasn't reached player position, then move towards player
			if not enemy_pos_reached and enemy_pos != null:
				var path = pathfinding.get_new_path(global_position, enemy_pos)

				if path.size()>1:
					if actor.global_position.distance_to(enemy_pos) <150:
						enemy_pos_reached = true
						enemy_pos = null
					else:
						actorVelocity = actor.velocity_towards(path[1])
						actor.rotate_towards(path[1])
						actor.move_and_slide(actorVelocity)

				else:
					enemy_pos_reached = true
					actorVelocity = Vector2.ZERO
		#Engage state
		State.ENGAGE:
			#if player data isn't null, then move towards and engage enemy
			if player != null and weapon != null:
				var path = pathfinding.get_new_path(global_position, player.global_position)
				actor.rotate_towards(player.global_position)
				if path.size()>1:
					if actor.global_position.distance_to(player.global_position) <200:
						var angleToPlayer = actor.global_position.direction_to(player.global_position).angle()
						if abs(actor.rotation-angleToPlayer)< 0.1:
							weapon.shoot()
					else:
						actorVelocity = actor.velocity_towards(path[1])
						actor.rotate_towards(path[1])
						actor.move_and_slide(actorVelocity)
				else:
					var angleToPlayer = actor.global_position.direction_to(player.global_position).angle()
					if abs(actor.rotation-angleToPlayer)< 0.1:
						weapon.shoot()
			else:
				print("Weapon or player null in engage state")
		_:
			print("Error found in enemy state, setting state to patrol", current_state)
			set_state(State.PATROL)

#Initialise AI
func initialize(actor: Enemy, weapon: Weapon):
	self.actor = actor
	self.weapon = weapon
	origin = self.actor.global_position
	set_state(State.PATROL)
	weapon.connect("weapon_out_of_ammo", self, "handle_reload")

#Handle setting of new state
func set_state(new_state: int):
	if new_state == current_state:
		return
	
	
	if new_state == State.PATROL:
		if current_state != State.ENGAGE and player_in_body == false:
			patrolTimer.start()
			origin = actor.global_position
			patrol_location_reached = true
	if new_state == State.HUNT:
		if current_state != State.ENGAGE and player_in_body == false:
			enemy_pos_reached = false
			enemy_pos = player.global_position
	
	current_state = new_state
	emit_signal("state_changed", new_state)
	
#Is redundant
func get_new_target():
	pass

#If player enters detection body, engage player
func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body
		player_in_body = true

#Identify new patrol location
func patrolTimer_timeout():
	var patrol_range = 150
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	

#Is triggered by signal, handles reload
func handle_reload():
	weapon.start_reload()

#If player exits engagement zone move to patrol
func _on_PlayerEngagementZone_body_exited(body):
	if player and body == player:
		set_state(State.PATROL)
		player_in_body = false

