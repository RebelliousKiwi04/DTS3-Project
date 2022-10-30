extends Node2D

onready var bullet_manager = $BulletManager
onready var player := $Player
onready var gui = $GUI

func _ready():
	randomize()
	globals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	gui.set_active_player(player)
