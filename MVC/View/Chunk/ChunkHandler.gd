class_name ChunkHandler extends Node3D

var loadedChunk:Dictionary

func genChunkRadius(posX:int,posY:int,radius:int)->void:
	
	for i in loadedChunk.values():
		i.unload = true
	
	for x in range(-radius/2,radius/2+1):
		for y in range(-radius/2,radius/2+1):
			if(sqrt(pow(x,2)+pow(y,2)) < radius):
				if loadedChunk.has(Vector2i(x+posX,y+posY)):
					loadedChunk.get(Vector2i(x+posX,y+posY)).unload = false
				else:
					var chunk:Chunk = Chunk.new()
					chunk.setPos(x+posX,y+posY)
					chunk.genTerrain()
					chunk.unload = false
					add_child(chunk)
					loadedChunk[Vector2i(x+posX,y+posY)] = chunk
	
	for i in loadedChunk.values():
		if i.unload :
			remove_child(i)
			loadedChunk.erase(i.getPosition())
