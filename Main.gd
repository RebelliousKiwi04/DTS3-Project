extends Node2D

const enemy = preload("res://actors//Enemy.tscn")

onready var bullet_manager = $BulletManager
onready var player := $Player
onready var gui = $GUI
onready var ground = $Ground
onready var pathfinding = $PathfindingHandler
onready var enemyspawns = $EnemySpawnPoints

var spawnpoints

func _ready():
	randomize()
	spawnpoints = enemyspawns.get_children()
	globals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	
	pathfinding.create_nav_map(ground)
	
	player.connect("player_died", self, "handle_player_death")
	gui.set_active_player(player)
	spawn_enemy()

func handle_player_death():
	print("Handling Player Death")

func spawn_enemy():
	var newEnemy = enemy.instance()
	add_child(newEnemy)
	newEnemy.global_position = spawnpoints[0].global_position
	newEnemy.ai.pathfinding = pathfinding
