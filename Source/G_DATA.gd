extends Node

var ipAdress:String
var pseudo:String
var password:String
var seed:int

var playerNameDico:Dictionary
var playerList:Array[Player]
var playerFocus:Player

func clear()->void:
	ipAdress = ""
	pseudo = ""
	password = ""
	seed = -1
	playerFocus = null
	playerNameDico.clear()
