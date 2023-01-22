extends ColorRect

@export var GameplayScene: String
@export var OptionsScene: String


func _on_start_button_pressed():
	Game.emit_signal("ChangeScene", GameplayScene)


func _on_options_button_pressed():
	Game.emit_signal("ChangeScene", OptionsScene)


func _on_exit_button_pressed():
	get_tree().quit()
