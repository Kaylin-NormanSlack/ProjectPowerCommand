extends Node

const DEFAULT_IP= '127.0.0.1'
const DEFAULT_PORT = 31400
const MAX_PLAYERS = 4

var players = {}
var self_data = { name = '', position = Vector2(360,180)}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _process(delta):
	pass

func create_server(player_nickname):
	self_data.name = player_nickname
	players[1] = self_data
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(DEFAULT_PORT,MAX_PLAYERS)
	get_tree().set_network_peer(peer)

func connect_to_server(player_nickname):
	self_data.name = player_nickname
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(DEFAULT_IP,DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	
func _connected_to_server():
	get_tree().connect("connected_to_server", _connected_to_server())
	players[get_tree().get_network_unique_id()] = self_data
	rpc('_send_player_info',get_tree().get_network_unique_id(),self_data)

func _player_connected(id):
	print("Player connected: " + str(id))
	pass

func _player_disconnected(id):
	get_tree().connect("network_peer_disconnected", _player_disconnected(id))
	players.erase(id)
	print("Player disconnected: " + str(id))
	pass

@rpc(any_peer)
func _send_player_info(id, info):
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id,'_send_player_info', peer_id, players[peer_id])
	players[id]=info
	
	var new_player = load("res://Units/Player/Player.tscn").instance()
	new_player.name = str(id)
	new_player.set_network_master(id)
	get_tree().root.add_child(new_player)
	new_player.init(info.name,info.position,true)

func update_position(id,position):
	players[id].position = position

