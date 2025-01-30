class_name Main extends Node

var menuUIPacked:PackedScene = preload("res://Source/MenuUI/MenuUI.tscn")
var gamePacked:PackedScene = preload("res://Source/Game/Game.tscn")

@onready var networkInit:NetworkInit = $NetworkInit

@onready var menuUI:MenuUI = $MenuUI
@onready var game:Game = $Game

var state
const STATE_MENU_IDLE = 0
const STATE_NETWORK_INIT = 1
const STATE_GAME_LOADING = 2
const STATE_GAME_IDLE = 100

func _ready() -> void:
	menuUI.host.connect(host)
	menuUI.join.connect(join)
	networkInit.menuUI = menuUI
	state = STATE_MENU_IDLE
	game.hide()

func _process(delta: float) -> void:
	match state:
		STATE_NETWORK_INIT:
			match networkInit.state:
				networkInit.STATE_DONE:
					menuUI.setLoadingScreenText("Loading game")
					state = STATE_GAME_LOADING
					if(multiplayer.is_server()):game.addServerPlayer()
				networkInit.STATE_ERROR_UPNP:
					menuUI.loadNetworkFailMenu()
					menuUI.setNetworkFailText("Error UPNP : failed to initialize")
					state = STATE_MENU_IDLE
				networkInit.STATE_ERROR_CONNECTION_FAILED:
					menuUI.loadNetworkFailMenu()
					menuUI.setNetworkFailText("Error connection failed")
					state = STATE_MENU_IDLE
					game.hide()
		STATE_GAME_LOADING:
			if(game.isGameLoaded()):
				menuUI.unloadMenu()
				game.show()
				state = STATE_GAME_IDLE


func host(pseudo: String, password: String, seed: int, upnp: bool) -> void:
	G_DATA.clear()
	G_DATA.pseudo = pseudo
	G_DATA.password = password
	G_DATA.seed = seed
	G_DATA.playerNameDico[1] = pseudo
	networkInit.reset()
	game.reset()
	
	networkInit.host(upnp)
	state = STATE_NETWORK_INIT
	
func join(pseudo: String, password: String, ipAdress: String) -> void:
	G_DATA.clear()
	G_DATA.pseudo = pseudo
	G_DATA.password = password
	G_DATA.ipAdress = ipAdress
	networkInit.reset()
	game.reset()
	
	networkInit.join()
	state = STATE_NETWORK_INIT

func _on_network_init_disconnected_from_server() -> void:
	menuUI.loadNetworkFailMenu()
	menuUI.setNetworkFailText("Disconnected from server")
	state = STATE_MENU_IDLE
func _on_network_init_player_connected(id: int) -> void:
	game.addPlayer(id)
