extends Node2D


export (int) var health = 100 setget set_health
#Health handler script, to handle health var, separated for ease, though is probably inefficient
func set_health(newHealth:int)->void:
	health = clamp(newHealth, 0,100)
