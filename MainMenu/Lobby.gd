extends CanvasLayer

var _player_name = ""	

func _on_CreateButton_pressed():
	if _player_name == "":
		return
	Network.create_server(_player_name)
	_load_game()

func _on_JoinButton_pressed():
	if _player_name == "":
		return
	Network.connect_to_server(_player_name)
	_load_game()

func _load_game():
	Game.emit_signal("ChangeScene","res://Gameplay.tscn")


func _on_LineEdit_text_changed(new_text: String) -> void:
	_player_name = new_text
	pass # Replace with function body.
