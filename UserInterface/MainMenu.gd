extends ColorRect

@export var Next_Scene: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	Game.emit_signal("ChangeScene",Next_Scene)


func _on_exit_button_pressed():
	get_tree().quit()


func _on_options_button_pressed():
	pass # Replace with function body.
