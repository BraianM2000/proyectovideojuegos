extends MarginContainer

func _on_NewGame_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level1.tscn")


func _on_Continue_pressed():
	pass # Replace with function body.


func _on_Options_pressed():
	get_tree().change_scene("res://Scenes/Options.tscn")
