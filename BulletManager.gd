extends Node2D

#Bullet manager exists to handle bullet spawning under a specific node
func handle_bullet_spawned(bullet: Bullet, position, direction):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_dir(direction)
