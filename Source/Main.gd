class_name Main extends Node

var menuUIPacked:PackedScene = preload("res://Source/MenuUI/MenuUI.tscn")
var gamePacked:PackedScene = preload("res://Source/Game/Game.tscn")

var networkInit:NetworkInit

func _ready() -> void:
	loadMenuUI()

func loadMenuUI():
	var menuUI:MenuUI = menuUIPacked.instantiate()
	menuUI.host.connect(host)
	menuUI.join.connect(join)
	add_child(menuUI)

func host(pseudo: String, password: String, seed: int, upnp: bool) -> void:
	networkInit = NetworkInit.new()
	networkInit.host(pseudo, password, seed, upnp)
func join(pseudo: String, password: String, ipAdress: String) -> void:
	networkInit = NetworkInit.new()
	networkInit.join(pseudo,password,ipAdress)
