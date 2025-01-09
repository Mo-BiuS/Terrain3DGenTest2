class_name NoiseGenerator

var noise:FastNoiseLite = FastNoiseLite.new()
var map:Image

func setSeed(seed:int):
	noise.seed = seed

func genNoiseMap(posX:int,posY:int,rX:int,rY:int,scale:float):
	noise.offset = Vector3(posX-rX,posY-rY,0)
	map = noise.get_image(rX*2,rY*2,false,false,false)
