extends CanvasLayer

#Maps in table for easy addition of extra maps to randomly select
var maps = [
	"res://Main.tscn"
	]

#Quit Game on Button Press
func _on_QuitButton_pressed():
	get_tree().quit()

#Randomizes to reseed randrange, then randomly selects map from list
func _on_StartButton_pressed():
	randomize()
	globals.used_map = maps[rand_range(0,maps.size()-1)]
	get_tree().change_scene(globals.used_map)

#Loads high score screen
func _on_HighScoreButton_pressed():
	get_tree().change_scene("res://HighScoreScreen.tscn")
