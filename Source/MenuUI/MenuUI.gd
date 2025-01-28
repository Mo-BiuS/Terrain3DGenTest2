class_name MenuUI extends CanvasLayer

@onready var multiplayerMenu:MultiplayerMenu=$MultiplayerMenu
@onready var hostMenu:HostMenu=$HostMenu
@onready var joinMenu:JoinMenu=$JoinMenu

signal host(pseudo:String, password:String, seed:int, upnp:bool)
signal join(pseudo:String, password:String, ipAdress:String)

func _ready() -> void:
	for i in get_children():i.hide()
	multiplayerMenu.show()

############[MultiplayerMenu]############
func _on_multiplayer_menu_host() -> void:
	multiplayerMenu.hide()
	hostMenu.init()
	hostMenu.show()
func _on_multiplayer_menu_join() -> void:
	multiplayerMenu.hide()
	joinMenu.show()
	joinMenu.init()

func _on_host_menu_host(pseudo: String, password: String, seed: int, upnp: bool) -> void:
	hostMenu.hide()
	host.emit(pseudo, password, seed, upnp)
func _on_host_menu_go_back() -> void:
	hostMenu.hide()
	multiplayerMenu.show()


func _on_join_menu_join(pseudo: String, password: String, ipAdress: String) -> void:
	joinMenu.hide()
	join.emit(pseudo, password, ipAdress)
func _on_join_menu_go_back() -> void:
	joinMenu.hide()
	multiplayerMenu.show()
