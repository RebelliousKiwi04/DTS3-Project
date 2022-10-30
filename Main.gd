extends Node2D

onready var bullet_manager = $BulletManager
onready var player := $Player
onready var gui = $GUI

func _ready():
	randomize()
	globals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	player.connect("player_died", self, "handle_player_death")
	gui.set_active_player(player)


func handle_player_death():
	print("Handling Player Death")
