extends Node2D


export (int) var health = 100 setget set_health

func set_health(newHealth:int)->void:
	health = clamp(newHealth, 0,100)
