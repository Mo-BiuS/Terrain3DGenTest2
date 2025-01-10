class_name MapHandler extends Node3D

@onready var chunckHandler:ChunkHandler = $ChunkHandler

func genChunkRadius(posX:int,posY:int,radius:int):
	chunckHandler.genChunkRadius(posX,posY,radius)
	chunckHandler.genTerrainAll()
