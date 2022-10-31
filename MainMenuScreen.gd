extends CanvasLayer


var maps = [
	"res://Main.tscn"
	]

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_StartButton_pressed():
	randomize()
	get_tree().change_scene(maps[rand_range(0,maps.size()-1)])


func _on_HighScoreButton_pressed():
	get_tree().change_scene("res://HighScoreScreen.tscn")
