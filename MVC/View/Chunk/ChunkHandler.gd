class_name ChunkHandler extends Node

var loadedChunk:Dictionary

var threadGenTerrainLOW:Thread
var threadGenTerrainNORMAL:Thread
var threadGenTerrainHIGH:Thread

func genChunkRadius(posX:int,posY:int,radius:int,seed:int):
	var priorityHIGH:Array[Chunk]
	var priorityNORMAL:Array[Chunk]
	var priorityLOW:Array[Chunk]
	
	
	for i in loadedChunk.values():
		i.unload = true
	
	for x in range(-radius,radius+1):
		for y in range(-radius,radius+1):
			var dist:float = sqrt(pow(x,2)+pow(y,2))
			if(dist < radius):
				if loadedChunk.has(Vector2i(x+posX,y+posY)):
					var chunk:Chunk = loadedChunk.get(Vector2i(x+posX,y+posY))
					chunk.unload = false
					chunk.calcNewDetails(dist)
					if(chunk.newDetails == 1):priorityHIGH.append(chunk)
					elif(chunk.newDetails < 8):priorityNORMAL.append(chunk)
					else:priorityLOW.append(chunk)
					
				else:
					var chunk:Chunk = Chunk.new()
					chunk.calcNewDetails(dist)
					chunk.setPos(x+posX,y+posY)
					chunk.unload = false
					add_child(chunk,true)
					loadedChunk[Vector2i(x+posX,y+posY)] = chunk
					if(chunk.newDetails == 1):priorityHIGH.append(chunk)
					elif(chunk.newDetails < 8):priorityNORMAL.append(chunk)
					else:priorityLOW.append(chunk)
	
	for i in loadedChunk.values():
		if i.unload :
			remove_child(i)
			loadedChunk.erase(i.getPosition())
			i.queue_free()
	
	for x in range(-radius,radius+1):
		for y in range(-radius,radius+1):
			var i = loadedChunk.get(Vector2i(x,y))
			if(i != null && i is Chunk):
				if(loadedChunk.has(Vector2i(x-1,y))):i.neighbors[0] = loadedChunk.get(Vector2i(x-1,y))
				if(loadedChunk.has(Vector2i(x,y+1))):i.neighbors[1] = loadedChunk.get(Vector2i(x,y+1))
				if(loadedChunk.has(Vector2i(x+1,y))):i.neighbors[2] = loadedChunk.get(Vector2i(x+1,y))
				if(loadedChunk.has(Vector2i(x,y-1))):i.neighbors[3] = loadedChunk.get(Vector2i(x,y-1))
	
	threadGenTerrainLOW = Thread.new()
	threadGenTerrainNORMAL = Thread.new()
	threadGenTerrainHIGH = Thread.new()
	
	threadGenTerrainHIGH.start(genTerrain.bind(priorityHIGH, seed),Thread.PRIORITY_HIGH)
	threadGenTerrainNORMAL.start(genTerrain.bind(priorityNORMAL, seed),Thread.PRIORITY_NORMAL)
	threadGenTerrainLOW.start(genTerrain.bind(priorityLOW, seed),Thread.PRIORITY_LOW)

func genTerrain(list:Array[Chunk], seed)->void:
	for i in list:
		i.genTerrain(seed)

func getChunkDetailsLevel(x:int,y:int)->int:
	if(loadedChunk.has(Vector2i(x,y))):return loadedChunk.get(Vector2i(x,y)).newDetails
	return -1
