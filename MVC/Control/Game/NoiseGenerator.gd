class_name NoiseGenerator extends Node

const SCALE = 64

var noise:FastNoiseLite = FastNoiseLite.new()
var seed:int

func setSeed(s:int)->void:
	self.seed = s
func getSeed()->int:
	return noise.seed

func getPoint(x,y)->float:
	return noise.get_noise_2d(x,y)

func setOffset(posX:int,posY:int)->void:
	noise.offset = Vector3(posX,posY,0)

func setBaseMap()->void:
	noise.seed = seed
	noise.noise_type = noise.TYPE_SIMPLEX_SMOOTH
	noise.fractal_octaves = 6 #default 5
	noise.frequency = 0.001 #default 0.01
	noise.fractal_lacunarity = 2.0 #default 2.0
	noise.fractal_gain = .4 #default 0.5

func setHillMap()->void:
	noise.seed = seed
	noise.noise_type = noise.TYPE_PERLIN
	noise.fractal_octaves = 4 #default 5
	noise.frequency = 0.0006 #default 0.01
	noise.fractal_lacunarity = 2.0 #default 2.0
	noise.fractal_gain = 0.8 #default 0.5
