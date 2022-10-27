extends Node2D


signal state_changed(new_state)


#Finite State Machine states
enum State {
	PATROL,
	ENGAGE
}


onready var playerDetectionZone = $PlayerDetectionZone


var current_state = State.PATROL setget set_state
var player: Player = null
var weapon: Weapon = null
var actor: Enemy = null

func _process(delta) -> void:
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if player != null and weapon != null:
				actor.rotation = actor.global_position.direction_to(player.global_position).angle()
				weapon.shoot()
			else:
				print("Weapon or player null in engage state")
		_:
			print("Error found in enemy state, setting state to patrol", current_state)
			set_state(State.PATROL)


func initialize(actor: Enemy, weapon: Weapon):
	self.actor = actor
	self.weapon = weapon


func set_state(new_state: int):
	if new_state == current_state:
		return
	current_state = new_state
	emit_signal("state_changed", new_state)


func get_new_target():
	pass


func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body
