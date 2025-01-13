class_name MapHandler extends Node

@onready var game:Game = $".."
@onready var chunckHandler:ChunkHandler = $ChunkHandler

func changedChunk(posX, posY) -> void:
	chunckHandler.genChunkRadius(posX,posY,16,game.seed)
