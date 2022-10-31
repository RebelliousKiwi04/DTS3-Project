extends Node2D
#Pathfinding script, uses Astar
class_name pathfinding


var astar = AStar2D.new()
var tilemap: TileMap
var half_cell_size: Vector2
var used_rect: Rect2

#Update nav map 60 times a second, could do this on signals but was easier this way
func _physics_process(delta):
	update_nav_map()

#Function to update navigation map to avoid obstacles, player or tile
func update_nav_map():
	for point in astar.get_points():
		astar.set_point_disabled(point, false)

	var obstacles = get_tree().get_nodes_in_group("obstacles")

	for obstacle in obstacles:
		if obstacle is TileMap:
			var tiles = obstacle.get_used_cells()
			for tile in tiles:
				var id = get_id_for_point(tile)
				if astar.has_point(id):
					astar.set_point_disabled(id, true)
		if obstacle is KinematicBody2D:
			var tile_coord = tilemap.world_to_map(obstacle.collision_shape.global_position)
			var id = get_id_for_point(tile_coord)
			if astar.has_point(id):
				astar.set_point_disabled(id, true)

#Create initial nav map
func create_nav_map(tilemap: TileMap):
	self.tilemap = tilemap
	
	half_cell_size = tilemap.cell_size / 2
	used_rect = tilemap.get_used_rect()
	
	var tiles = tilemap.get_used_cells()
	
	add_traversible_tiles(tiles)
	connect_traversible_tiles(tiles)
	
#Add traversible tiles to astar
func add_traversible_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		astar.add_point(id, tile)

#Connect traversible tiles in Astar grid
func connect_traversible_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)

		for x in range(3):
			for y in range(3):
				var target = tile + Vector2(x - 1, y - 1)
				var target_id = get_id_for_point(target)

				if tile == target or not astar.has_point(target_id):
					continue

				astar.connect_points(id, target_id, true)

#Get id for points on tilemap
func get_id_for_point(point: Vector2):
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y
	
	return x + y * used_rect.size.x

#Return path from one point to another, returns null if point isn't traversible
func get_new_path(start: Vector2, end: Vector2):
	var start_tile = tilemap.world_to_map(start)
	var end_tile = tilemap.world_to_map(end)
	
	var start_id = get_id_for_point(start_tile)
	var end_id = get_id_for_point(end_tile)

	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return []

	var path_map = astar.get_point_path(start_id, end_id)

	var path_world = []
	for point in path_map:
		var point_world = tilemap.map_to_world(point) + half_cell_size
		path_world.append(point_world)

	return path_world
