class_name MenuUI extends CanvasLayer

var multiplayerMenuPacked:PackedScene=preload("res://Source/MenuUI/MultiplayerMenu.tscn")
var hostMenuPacked:PackedScene=preload("res://Source/MenuUI/HostMenu.tscn")
var joinMenuPacked:PackedScene=preload("res://Source/MenuUI/JoinMenu.tscn")

signal host(pseudo:String, password:String, seed:int, upnp:bool)
signal join(pseudo:String, password:String, ipAdress:String)

func _ready() -> void:
	loadMultiplayerMenu()

############[MultiplayerMenu]############
func loadMultiplayerMenu() -> void:
	var multiplayerMenu:MultiplayerMenu = multiplayerMenuPacked.instantiate()
	multiplayerMenu.host.connect(toHostMenu)
	multiplayerMenu.join.connect(toJoinMenu)
	add_child(multiplayerMenu)
func toHostMenu() -> void:
	for i in get_children():i.queue_free()
	loadHostMenu()
func toJoinMenu() -> void:
	for i in get_children():i.queue_free()
	loadJoinMenu()
func toMultiplayerMenu() -> void:
	for i in get_children():i.queue_free()
	loadMultiplayerMenu()

############[hostMenu]############
func loadHostMenu() -> void:
	var hostMenu:HostMenu = hostMenuPacked.instantiate()
	hostMenu.toMultiplayerMenu.connect(toMultiplayerMenu)
	hostMenu.host.connect(menuHost)
	add_child(hostMenu)
func menuHost(pseudo:String, password:String, seed:int, upnp:bool):
	for i in get_children():i.queue_free()
	host.emit(pseudo, password, seed, upnp)
############[joinMenu]############
func loadJoinMenu() -> void:
	var joinMenu:JoinMenu = joinMenuPacked.instantiate()
	joinMenu.toMultiplayerMenu.connect(toMultiplayerMenu)
	joinMenu.join.connect(menuJoin)
	add_child(joinMenu)
func menuJoin(pseudo:String, password:String, ipAdress:String) -> void:
	for i in get_children():i.queue_free()
	join.emit(pseudo, password, ipAdress)
