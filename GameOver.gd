extends CanvasLayer
#Game Over Screen script
onready var scoreLabel = $PanelContainer/MarginContainer/Rows/ScoreLabel

#Loads and adds score to saved data
func _ready():
	var scoreFile = File.new()
	scoreFile.open("user://high_scores.dat", File.READ)
	var scores = []
	if scoreFile.get_var():
		scoreFile.get_var()
	scoreFile.close()
	scoreLabel.text = "Score: "+str(globals.score)
	scores.append(globals.score)
	scores.sort()
	scoreFile  = File.new()
	scoreFile.open("user://high_scores.dat", File.WRITE)
	scoreFile.store_var(scores)
	scoreFile.close()

#Reopens scene you just lost on
func _on_RetryButton_pressed():
	get_tree().change_scene(globals.used_map)

#Quits Game
func _on_QuitButton_pressed():
	get_tree().quit()

#Takes you back to main menu
func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://MainMenuScreen.tscn")
