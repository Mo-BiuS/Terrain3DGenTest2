class_name NoiseGenerator

var noise:FastNoiseLite = FastNoiseLite.new()
var minimap:TextureRect = TextureRect.new()
var map:Dictionary

func setSeed(seed:int):
	noise.seed = seed

func genNoiseMap(posX:int,posY:int,rX:int,rY:int,scale:float):
	map.clear()
	for x in range(posX-rX,posX+rX):
		for y in range(posY-rY,posY+rY):
			if(!map.has(Vector2(x,y)) && sqrt(pow(x-posX,2)+pow(y-posY,2)) < rX):
				var sampleX:float = x/scale
				var sampleY:float = y/scale
				map[Vector2(x,y)] = (noise.get_noise_2d(x,y))

func genMinimap(posX:int,posY:int,rX:int,rY:int):
	noise.offset = Vector3(posX,posY,0)
	var img = noise.get_image(rX,rY)
	minimap.texture = ImageTexture.create_from_image(img)
	
