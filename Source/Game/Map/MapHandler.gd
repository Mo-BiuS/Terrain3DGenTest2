class_name MapHandler extends Node

@onready var game:Game = $".."
@onready var chunckHandler:ChunkHandler = $ChunkHandler

func reset()->void:
	chunckHandler.reset()

func setPlayerFocus(p:Player)->void:
	p.changedChunk.connect(changedChunk)
	G_DATA.playerFocus = p

func isMapLoaded()->bool:
	return chunckHandler.isAllChunkLoaded()

func changedChunk(posX:int, posY:int) -> void:
	chunckHandler.genChunkRadius(posX,posY,24,G_DATA.seed)

func getChunkDetailsLevel(x:int,y:int)->int:
	return chunckHandler.getChunkDetailsLevel(x,y)
