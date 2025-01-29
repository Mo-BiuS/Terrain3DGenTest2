class_name MenuUI extends CanvasLayer

var multiplayerMenuPacked:PackedScene=preload("res://Source/MenuUI/MultiplayerMenu.tscn")
var hostMenuPacked:PackedScene=preload("res://Source/MenuUI/HostMenu.tscn")
var joinMenuPacked:PackedScene=preload("res://Source/MenuUI/JoinMenu.tscn")
var loadingScreenMenuPacked:PackedScene=preload("res://Source/MenuUI/LoadingScreenMenu.tscn")
var upnpFailedMenuPacked:PackedScene=preload("res://Source/MenuUI/UpnpFailedMenu.tscn")

signal host(pseudo:String, password:String, seed:int, upnp:bool)
signal join(pseudo:String, password:String, ipAdress:String)

func _ready() -> void:
	loadMultiplayerMenu()

############[MultiplayerMenu]############
func loadMultiplayerMenu() -> void:
	for i in get_children():i.queue_free()
	var multiplayerMenu:MultiplayerMenu = multiplayerMenuPacked.instantiate()
	multiplayerMenu.host.connect(toHostMenu)
	multiplayerMenu.join.connect(toJoinMenu)
	add_child(multiplayerMenu)
func toHostMenu() -> void:
	loadHostMenu()
func toJoinMenu() -> void:
	loadJoinMenu()
func toMultiplayerMenu() -> void:
	loadMultiplayerMenu()

############[hostMenu]############
func loadHostMenu() -> void:
	for i in get_children():i.queue_free()
	var hostMenu:HostMenu = hostMenuPacked.instantiate()
	hostMenu.toMultiplayerMenu.connect(toMultiplayerMenu)
	hostMenu.host.connect(menuHost)
	add_child(hostMenu)
func menuHost(pseudo:String, password:String, seed:int, upnp:bool):
	loadLoadingScreenMenu()
	host.emit(pseudo, password, seed, upnp)
############[joinMenu]############
func loadJoinMenu() -> void:
	for i in get_children():i.queue_free()
	var joinMenu:JoinMenu = joinMenuPacked.instantiate()
	joinMenu.toMultiplayerMenu.connect(toMultiplayerMenu)
	joinMenu.join.connect(menuJoin)
	add_child(joinMenu)
func menuJoin(pseudo:String, password:String, ipAdress:String) -> void:
	loadLoadingScreenMenu()
	join.emit(pseudo, password, ipAdress)

############[loadingScreenMenu]############
func loadLoadingScreenMenu()->void:
	for i in get_children():i.queue_free()
	var loadingScreenMenu:LoadingScreenMenu = loadingScreenMenuPacked.instantiate()
	add_child(loadingScreenMenu)
func setLoadingScreenText(text:String)->void:
	for i in get_children():
		if i is LoadingScreenMenu:i.setText(text)

############[upnpFailedMenu]############
func loadUpnpFailedMenu()->void:
	for i in get_children():i.queue_free()
	var upnpFailedMenu:UpnpFailedMenu = upnpFailedMenuPacked.instantiate()
	upnpFailedMenu.returnToMenu.connect(loadMultiplayerMenu)
	add_child(upnpFailedMenu)
