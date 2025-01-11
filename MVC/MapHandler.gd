class_name MapHandler extends Node

@onready var chunckHandler:ChunkHandler = $ChunkHandler
@onready var noiseGenerator:NoiseGenerator = $"../NoiseGenerator"

func changedChunk(posX, posY) -> void:
	chunckHandler.genChunkRadius(posX,posY,6)
	chunckHandler.genTerrainAll(noiseGenerator.getSeed())
