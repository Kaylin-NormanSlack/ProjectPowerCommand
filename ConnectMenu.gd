extends VBoxContainer

var multiplayer_peer = ENetMultiplayerPeer.new()
@onready var menu = $ConnectMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_join_pressed():
	var port = str($ConnectMenu/Port.text).to_int()
	multiplayer_peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false


func _on_host_pressed():
	var port = str($ConnectMenu/Port.text).to_int()
	multiplayer_peer.create_server(port)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(func(id): add_player_character(id))
	menu.visible = false
	add_player_character()


func add_player_character(id=1):
	var character = preload("res://Units/Player/Player.tscn").instantiate()
	character.name = str(id)
	add_child(character)
