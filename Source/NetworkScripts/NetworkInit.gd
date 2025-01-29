class_name NetworkInit extends Node

const PORT:int = 8624

var menuUI:MenuUI
var state:int = 0

var networkInitThread:Thread

var enet_peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()

const STATE_ONGOING = 0
const STATE_DONE = 1
const STATE_ERROR_UPNP = 2
const STATE_ERROR_CONNECTION_FAILED = 3

signal disconnectedFromServer
signal playerConnected(id:int)

func _ready() -> void:
	multiplayer.peer_connected.connect(peerConnected)
	multiplayer.peer_disconnected.connect(peerDisconnected)
	multiplayer.connected_to_server.connect(connectedToServer)
	multiplayer.connection_failed.connect(connectionFailed)
	multiplayer.server_disconnected.connect(serverDisconnected)

func reset()->void:
	enet_peer.close()
	enet_peer = ENetMultiplayerPeer.new()
	multiplayer.multiplayer_peer = null

func peerConnected(_id:int):
	pass
func peerDisconnected(_id:int):
	pass
func connectedToServer()->void:
	menuUI.setLoadingScreenText("Connecting to server")
	sendServerData.rpc_id(1,G_DATA.pseudo,G_DATA.password,multiplayer.get_unique_id())
func connectionFailed()->void:
	state = STATE_ERROR_CONNECTION_FAILED
	multiplayer.multiplayer_peer.close()
func serverDisconnected():
	multiplayer.multiplayer_peer.close()
	disconnectedFromServer.emit()

func host(upnp: bool)->void:
	menuUI.setLoadingScreenText("Starting server : init")
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	if(upnp):
		networkInitThread = Thread.new()
		networkInitThread.start(startUPNP.bind())
	else:
		G_DATA.ipAdress = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
		print("IP adress : ",G_DATA.ipAdress)
		state = STATE_DONE

func startUPNP():
	menuUI.call_deferred("setLoadingScreenText","Starting server : upnp")
	
	var upnp:UPNP = UPNP.new()
	var success:bool = false
	var discover_result = upnp.discover()
	if(discover_result != UPNP.UPNP_RESULT_SUCCESS):print("UPNP Discover Failed! Error %s" % discover_result)
	elif(!(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway())):print("UPNP Invalid Gateway!")
	else:
		var map_result = upnp.add_port_mapping(PORT)
		if(map_result != UPNP.UPNP_RESULT_SUCCESS):print("UPNP port mapping failed! Error %s" % map_result)
		else:success=true
	
	if(!success):
		state = STATE_ERROR_UPNP
	else:
		G_DATA.ipAdress = upnp.query_external_address()
		print("UPNP IP adress : ",G_DATA.ipAdress)
		state = STATE_DONE

func join()->void:
	enet_peer.create_client(G_DATA.ipAdress, PORT)
	multiplayer.multiplayer_peer = enet_peer
	menuUI.setLoadingScreenText("Searching server")

@rpc("any_peer")
func sendServerData(pseudo:String, password:String, id:int)->void:
	if(G_DATA.password == password):
		if(!G_DATA.playerNameDico.values().has(pseudo)):
			confirmConnection.rpc_id(id, G_DATA.seed)
			G_DATA.playerNameDico[id] = pseudo
			playerConnected.emit(id)
		else:
			multiplayer.disconnect_peer(id)
	else:
		multiplayer.disconnect_peer(id)

@rpc("any_peer")
func confirmConnection(seed:int)->void:
	G_DATA.seed = seed
	state = STATE_DONE
