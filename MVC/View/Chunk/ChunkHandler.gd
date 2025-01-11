class_name ChunkHandler extends Node

var loadedChunk:Dictionary

func genChunkRadius(posX:int,posY:int,radius:int):
	for i in loadedChunk.values():
		i.unload = true
	
	for x in range(-radius,radius+1):
		for y in range(-radius,radius+1):
			if(sqrt(pow(x,2)+pow(y,2)) < radius):
				if loadedChunk.has(Vector2i(x+posX,y+posY)):
					loadedChunk.get(Vector2i(x+posX,y+posY)).unload = false
				else:
					var chunk:Chunk = Chunk.new()
					chunk.setPos(x+posX,y+posY)
					chunk.unload = false
					add_child(chunk,true)
					loadedChunk[Vector2i(x+posX,y+posY)] = chunk
	
	for i in loadedChunk.values():
		if i.unload :
			remove_child(i)
			loadedChunk.erase(i.getPosition())

func genTerrainAll(seed)->void:
	for i in loadedChunk.values():
		if(i is Chunk):
			i.genTerrain(seed)
			
