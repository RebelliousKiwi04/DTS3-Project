extends CanvasLayer




func _on_ResumeButton_pressed():
	get_tree().paused = false
	queue_free()
	


func _on_QuitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://MainMenuScreen.tscn")


func _on_HelpButton_pressed():
	pass # Replace with function body.
