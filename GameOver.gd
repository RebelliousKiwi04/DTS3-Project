extends CanvasLayer

onready var scoreLabel = $PanelContainer/MarginContainer/Rows/ScoreLabel

func _ready():
	var scoreFile = File.new()
	scoreFile.open("user://high_scores.dat", File.READ)
	var scores = scoreFile.get_var()
	scoreFile.close()
	scoreLabel.text = "Score: "+str(globals.score)
	scores.append(globals.score)
	scores.sort()
	scoreFile  = File.new()
	scoreFile.open("user://high_scores.dat", File.WRITE)
	scoreFile.store_var(scores)
	scoreFile.close()

func _on_RetryButton_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://MainMenuScreen.tscn")
