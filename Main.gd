extends Node2D

const enemy = preload("res://actors//Enemy.tscn")
const pauseMenu = preload("res://UI//PauseScreen.tscn")

onready var bullet_manager = $BulletManager
onready var player := $Player
onready var gui = $GUI
onready var ground = $Ground
onready var pathfinding = $PathfindingHandler
onready var enemyspawns = $EnemySpawnPoints
onready var enemyContainer = $EnemyContainer

var spawnpoints

func _ready():
	randomize()
	spawnpoints = enemyspawns.get_children()
	globals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	
	pathfinding.create_nav_map(ground)
	
	player.connect("player_died", self, "handle_player_death")
	gui.set_active_player(player)
	
	_on_HuntTimer_timeout()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		get_tree().paused = true
		add_child(pauseMenu.instance())

	
func spawn_enemies():
	gui.set_info_label("Spawning Enemies")
	for i in range(0,5):
		spawn_enemy(i)
	
	
func handle_player_death():
	get_tree().change_scene("res://GameOver.tscn")

func spawn_enemy(spawnPoint):
	var newEnemy = enemy.instance()
	enemyContainer.add_child(newEnemy)
	newEnemy.global_position = spawnpoints[spawnPoint].global_position
	newEnemy.ai.pathfinding = pathfinding
	newEnemy.ai.player = player
	newEnemy.connect("enemyDied", self, "handle_enemy_death")

func handle_enemy_death():
	globals.score+=50
	gui.set_score(globals.score)


func _on_HuntTimer_timeout():
	spawn_enemies()
	for i in enemyContainer.get_children():
		i.begin_hunt()
	
