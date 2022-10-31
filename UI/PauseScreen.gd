extends CanvasLayer
#Pause screen script
const helpScreen = preload("res://UI//HelpScreen.tscn")

#Close pause menu on resume button press
func _on_ResumeButton_pressed():
	get_tree().paused = false
	queue_free()
	
#Go to main menu upon quit button pressed
func _on_QuitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://MainMenuScreen.tscn")



func _on_HelpButton_pressed():
	get_parent().add_child(helpScreen.instance())
