extends CanvasLayer

@export var Main_Menu: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_button_pressed():
	print("continue")
	get_node(".").hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _on_back_to_start_pressed():
		Game.emit_signal("ChangeScene",Main_Menu)
