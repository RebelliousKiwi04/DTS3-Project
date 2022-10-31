extends CanvasLayer


onready var health_bar = $"MarginContainer/Rows/Bottom Row/HealthContainer/HealthBar"
onready var current_ammo = $"MarginContainer/Rows/Bottom Row/Ammo/CurrentAmmo"
onready var max_ammo = $"MarginContainer/Rows/Bottom Row/Ammo/MaxAmmo"
onready var health_tween = $"MarginContainer/Rows/Bottom Row/HealthContainer/health_tween"
onready var score_label = $"MarginContainer/Rows/Top Row/ScoreLabel"
onready var info_label = $"MarginContainer/Rows/Top Row/InfoLabel"
onready var info_timer = $infoTimer

var player: Player = null

func set_score(score: int):
	score_label.text = "Score: "+str(score)
	
func set_info_label(text):
	info_label.text =text
	info_timer.start()
	
func set_active_player(actor: Player) -> void:
	player = actor
	set_new_health_value(player.playerHealth.health)
	set_ammo_values(player.weapon.current_ammo, player.weapon.max_ammo)

	player.connect("player_health_changed", self, "set_new_health_value")
	player.weapon.connect("ammo_values_changed", self, "set_ammo_values")
	
func set_new_health_value(new_health: int) -> void:
	#Values for health bar anims
	var original_color = Color("#7a3333")
	var highlight_color = Color("#ff7e7e")
	var bar_style = health_bar.get("custom_styles/fg")
	#Health Bar anims using interpolations, whilst setting value
	health_tween.interpolate_property(health_bar, "value", health_bar.value, new_health, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	health_tween.interpolate_property(bar_style, "bg_color", original_color, highlight_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	health_tween.interpolate_property(bar_style, "bg_color", highlight_color, original_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	health_tween.start()
	
	
func set_ammo_values(ammo, new_max_ammo):
	current_ammo.text = str(ammo)
	max_ammo.text = str(new_max_ammo)


func _on_infoTimer_timeout():
	set_info_label("")
