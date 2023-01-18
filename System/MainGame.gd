extends Node

var port = 4000
var targetIP = "localhost"


@export
var PlayerScene = preload("res://Units/Player/Player.tscn")


func _enter_tree():
	# Start the server if Godot is passed the "--server" argument,
	# and start a client otherwise.
	if "--server" in OS.get_cmdline_args():
		start_network(true)
	else:
		start_network(false)

func start_network(server: bool) -> void:
	var peer = ENetMultiplayerPeer.new()
	if server:
		multiplayer.peer_connected.connect(self.create_player)
		multiplayer.peer_disconnected.connect(self.destroy_player)
		
		#peer.set_bind_ip(targetIP) #ARE YOU SERIOUS!?!?!?!?!?
		peer.create_server(port)
		print("server listening on " + targetIP )
	else:
		peer.create_client(targetIP, port)
		print("joining " + targetIP )

	multiplayer.set_multiplayer_peer(peer)



func create_player(id : int) -> void:
	var p = PlayerScene.instantiate()
	p.name = str(id)
	$Players.add_child(p)
	for player in $Players.get_children():
		print(str(id) + ": has connected. The amount of players is " + str($Players.get_child_count()))

func destroy_player(id : int) -> void:
	$Players.get_node(str(id)).queue_free()
	print(str(id) + ":Peer disconnected")


