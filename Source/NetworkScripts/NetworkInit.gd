class_name NetworkInit extends Node

const PORT:int = 8624

var menuUI:MenuUI
var state:int = 0

const STATE_ONGOING = 0
const STATE_DONE = 1
const STATE_ERROR_UPNP = 2

func host(upnp: bool)->void:
	menuUI.call_deferred("setLoadingScreenText","Starting server : init")
	
	var enet_peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	enet_peer.create_server(PORT)
	set_deferred("multiplayer.multiplayer_peer",enet_peer)
	
	if(upnp):startUPNP()
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
	pass
