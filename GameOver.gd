extends CanvasLayer

onready var scoreLabel = $PanelContainer/MarginContainer/Rows/ScoreLabel

func _ready():
	scoreLabel.text = "Score: "+str(globals.score)

func _on_RetryButton_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
