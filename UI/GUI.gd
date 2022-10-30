extends CanvasLayer


onready var health_bar = $"MarginContainer/Rows/Bottom Row/HealthContainer/HealthBar"
onready var current_ammo = $"MarginContainer/Rows/Bottom Row/Ammo/CurrentAmmo"
onready var max_ammo = $"MarginContainer/Rows/Bottom Row/Ammo/MaxAmmo"


var player: Player = null


func set_active_player(actor: Player) -> void:
	player = actor
	set_new_health_value(player.playerHealth.health)
	set_ammo_values(player.weapon.current_ammo, player.weapon.max_ammo)

	player.connect("player_health_changed", self, "set_new_health_value")
	player.weapon.connect("ammo_values_changed", self, "set_ammo_values")
	
func set_new_health_value(new_health: int) -> void:
	health_bar.value = new_health
	
func set_ammo_values(ammo, new_max_ammo):
	current_ammo.text = str(ammo)
	max_ammo.text = str(new_max_ammo)
