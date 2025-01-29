class_name Main extends Node

var menuUIPacked:PackedScene = preload("res://Source/MenuUI/MenuUI.tscn")
var gamePacked:PackedScene = preload("res://Source/Game/Game.tscn")

var networkInit:NetworkInit
var networkInitThread:Thread

var menuUI:MenuUI
var game:Game

var state
const STATE_MENU_IDLE = 0
const STATE_NETWORK_INIT = 1
const STATE_GAME_LOADING = 2
const STATE_GAME_IDLE = 100

func _ready() -> void:
	loadMenuUI()
	state = STATE_MENU_IDLE

func _process(delta: float) -> void:
	match state:
		STATE_NETWORK_INIT:
			match networkInit.state:
				networkInit.STATE_DONE:
					game = gamePacked.instantiate()
					add_child(game)
					networkInit.queue_free()
					menuUI.setLoadingScreenText("Loading game")
					state = STATE_GAME_LOADING
				networkInit.STATE_ERROR_UPNP:
					menuUI.loadUpnpFailedMenu()
					state = STATE_MENU_IDLE

func loadMenuUI():
	menuUI = menuUIPacked.instantiate()
	menuUI.host.connect(host)
	menuUI.join.connect(join)
	add_child(menuUI)

func host(pseudo: String, password: String, seed: int, upnp: bool) -> void:
	G_DATA.clear()
	G_DATA.pseudo = pseudo
	G_DATA.password = password
	G_DATA.seed = seed
	G_DATA.playerNameDico[1] = pseudo
	
	networkInit = NetworkInit.new()
	add_child(networkInit)
	networkInit.menuUI = menuUI
	networkInitThread = Thread.new()
	networkInitThread.start(networkInit.host.bind(upnp))
	state = STATE_NETWORK_INIT
	
func join(pseudo: String, password: String, ipAdress: String) -> void:
	G_DATA.clear()
	G_DATA.pseudo = pseudo
	G_DATA.password = password
	G_DATA.ipAdress = ipAdress
	
	networkInit = NetworkInit.new()
	add_child(networkInit)
	networkInit.menuUI = menuUI
	networkInitThread = Thread.new()
	networkInitThread.start(networkInit.join.bind())
	state = STATE_NETWORK_INIT
