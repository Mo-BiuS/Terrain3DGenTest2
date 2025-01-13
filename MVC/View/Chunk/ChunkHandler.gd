class_name ChunkHandler extends Node

var loadedChunk:Dictionary

func genChunkRadius(posX:int,posY:int,radius:int,seed:int):
	for i in loadedChunk.values():
		i.unload = true
	
	for x in range(-radius,radius+1):
		for y in range(-radius,radius+1):
			var dist:float = sqrt(pow(x,2)+pow(y,2))
			if(dist < radius):
				if loadedChunk.has(Vector2i(x+posX,y+posY)):
					var chunk:Chunk = loadedChunk.get(Vector2i(x+posX,y+posY))
					chunk.unload = false
					chunk.dist = dist
				else:
					var chunk:Chunk = Chunk.new()
					chunk.dist = dist
					chunk.setPos(x+posX,y+posY)
					chunk.unload = false
					add_child(chunk,true)
					loadedChunk[Vector2i(x+posX,y+posY)] = chunk
	
	for i in loadedChunk.values():
		if i.unload :
			remove_child(i)
			loadedChunk.erase(i.getPosition())
	
	for i in loadedChunk.values():
		i.genTerrain(seed)
