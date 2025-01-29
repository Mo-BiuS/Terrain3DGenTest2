class_name Game extends Node3D

@onready var mapHandler:MapHandler = $MapHandler
@onready var playerHandler:PlayerHandler = $PlayerHandler
@onready var gui:GameUI = $GameUI

var seed:int = G_DATA.seed

func isGameLoaded()->bool:
	return mapHandler.isMapLoaded()
func changedChunk(x:int, y:int):
	gui.setChunkPos(x,y,mapHandler.getChunkDetailsLevel(x,y))
	mapHandler.changedChunk(x,y)
