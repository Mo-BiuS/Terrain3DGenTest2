class_name Main extends Node

var menuUIPacked:PackedScene = preload("res://Source/MenuUI/MenuUI.tscn")
var gamePacked:PackedScene = preload("res://Source/Game/Game.tscn")

func _ready() -> void:
	loadMenuUI()

func loadMenuUI():
	var menuUI:MenuUI = menuUIPacked.instantiate()
	menuUI.host.connect(host)
	menuUI.join.connect(join)
	add_child(menuUI)

func host(pseudo: String, password: String, seed: int, upnp: bool) -> void:
	print(pseudo,password,seed,upnp)
func join(pseudo: String, password: String, ipAdress: String) -> void:
	print(pseudo,password,ipAdress)
