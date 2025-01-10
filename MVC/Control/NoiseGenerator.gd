class_name NoiseGenerator

const SCALE = 64

var noise:FastNoiseLite = FastNoiseLite.new()
var map:Image

func setSeed(seed:int):
	noise.seed = seed

func genNoiseMap(posX:int,posY:int,rX:int,rY:int):
	noise.offset = Vector3(posX,posY,0)
	map = noise.get_image(rX,rY,false,false,false)
