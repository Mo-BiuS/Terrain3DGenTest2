class_name MapHandler extends Node

@onready var game:Game = $".."
@onready var chunckHandler:ChunkHandler = $ChunkHandler

func changedChunk(posX:int, posY:int) -> void:
	chunckHandler.genChunkRadius(posX,posY,16,game.seed)

func getChunkDetailsLevel(x:int,y:int)->int:
	return chunckHandler.getChunkDetailsLevel(x,y)
