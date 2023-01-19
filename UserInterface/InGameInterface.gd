extends Control

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		print("paused")
		get_node("OptionsMenu").show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
