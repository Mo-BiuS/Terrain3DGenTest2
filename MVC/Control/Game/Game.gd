class_name Game extends Node

@onready var mapHandler:MapHandler = $MapHandler
@onready var playerHandler:PlayerHandler = $PlayerHandler
@onready var noiseGenerator:NoiseGenerator = $NoiseGenerator
@onready var gui:GameUI = $GameUI

var seed:int

func changedChunk(x:int, y:int):
	gui.setChunkPos(x,y)
	mapHandler.changedChunk(x,y)
