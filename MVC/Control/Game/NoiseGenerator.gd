class_name NoiseGenerator extends Node

const SCALE = 64

var noise:FastNoiseLite = FastNoiseLite.new()
var seed:int

func _ready() -> void:
	pass

func setSeed(s:int)->void:
	self.seed = s
func getSeed()->int:
	return noise.seed

func genBaseMap(posX:int,posY:int,rX:int,rY:int)->Image:
	noise.seed = seed
	noise.noise_type = noise.TYPE_SIMPLEX_SMOOTH
	noise.fractal_octaves = 6 #default 5
	noise.frequency = 0.001 #default 0.01
	noise.fractal_lacunarity = 2.0 #default 2.0
	noise.fractal_gain = .5 #default 0.5
	noise.offset = Vector3(posX,posY,0)
	var img:Image = noise.get_image(rX,rY,false,false,false)
	return img

func genHillMap(posX:int,posY:int,rX:int,rY:int)->Image:
	noise.seed = seed
	noise.noise_type = noise.TYPE_PERLIN
	noise.fractal_octaves = 5 #default 5
	noise.frequency = 0.01 #default 0.01
	noise.fractal_lacunarity = 2.0 #default 2.0
	noise.fractal_gain = 0.5 #default 0.5
	noise.offset = Vector3(posX,posY,0)
	return noise.get_image(rX,rY,false,false,false)
	
