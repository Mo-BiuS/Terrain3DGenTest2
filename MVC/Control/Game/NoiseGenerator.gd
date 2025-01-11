class_name NoiseGenerator extends Node

const SCALE = 64

var noise:FastNoiseLite = FastNoiseLite.new()
var map:Image

func setSeed(seed:int)->void:
	noise.seed = seed
func getSeed()->int:
	return noise.seed

func genNoiseMap(posX:int,posY:int,rX:int,rY:int)->void:
	noise.frequency = 0.005
	noise.fractal_lacunarity = 2
	noise.offset = Vector3(posX,posY,0)
	map = noise.get_image(rX,rY,false,false,false)
