extends CanvasLayer
#High Score Screen script
onready var scoreLabel = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/Score1

#Get and print scores
func _ready():
	var scoreFile = File.new()
	scoreFile.open("user://high_scores.dat", File.READ)
	
	var scores = []
	if scoreFile.get_var():
		scores = scoreFile.get_var()
		scoreFile.close()
		scores.sort()
		scores.invert()
		print(scores)
	else:
		scoreFile.close()
		scoreFile.open("user://high_scores.dat", File.WRITE)
		scoreFile.close()
	if scores.size() <=5:
		for i in range(0,5-scores.size()):
			scores.append(0)
	scoreLabel.text = "1. "+str(scores[0])+"\n2. "+str(scores[1])+"\n3. "+str(scores[2])+"\n4. "+str(scores[3])+"\n5. "+str(scores[4])

#On button pressed go to main menu
func _on_BackButton_pressed():
	get_tree().change_scene("res://MainMenuScreen.tscn")
