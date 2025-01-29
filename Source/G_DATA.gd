extends Node

var ipAdress:String
var pseudo:String
var password:String
var seed:int

var playerNameDico:Dictionary

func clear()->void:
	ipAdress = ""
	pseudo = ""
	password = ""
	seed = -1
	playerNameDico.clear()
