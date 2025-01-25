class_name NoiseGenerator extends Node

var baseNoise:FastNoiseLite = FastNoiseLite.new()
var montainNoise:FastNoiseLite = FastNoiseLite.new()
var hillNoise:FastNoiseLite = FastNoiseLite.new()
var groundNoise:FastNoiseLite = FastNoiseLite.new()

func init(seed:int,posX:int,posY:int)->void:
	baseNoise.seed = seed
	baseNoise.offset = Vector3(posX,posY,0)
	baseNoise.noise_type = baseNoise.TYPE_SIMPLEX_SMOOTH
	baseNoise.fractal_octaves = 6 #default 5
	baseNoise.frequency = 0.0004 #default 0.01
	baseNoise.fractal_lacunarity = 2.0 #default 2.0
	baseNoise.fractal_gain = 0.4 #default 0.5
	
	montainNoise.seed = seed
	montainNoise.offset = Vector3(posX,posY,0)
	montainNoise.noise_type = montainNoise.TYPE_SIMPLEX_SMOOTH
	montainNoise.fractal_octaves = 6 #default 5
	montainNoise.frequency = 0.002 #default 0.01
	montainNoise.fractal_lacunarity = 2.0 #default 2.0
	montainNoise.fractal_gain = .4 #default 0.5
	
	hillNoise.seed = seed
	hillNoise.offset = Vector3(posX,posY,0)
	hillNoise.noise_type = hillNoise.TYPE_PERLIN
	hillNoise.fractal_octaves = 4 #default 5
	hillNoise.frequency = 0.01 #default 0.01
	hillNoise.fractal_lacunarity = 2.0 #default 2.0
	hillNoise.fractal_gain = .5 #default 0.5
	
	groundNoise.seed = seed
	groundNoise.offset = Vector3(posX,posY,0)
	groundNoise.noise_type = groundNoise.TYPE_PERLIN
	groundNoise.fractal_octaves = 6 #default 5
	groundNoise.frequency = 0.008 #default 0.01
	groundNoise.fractal_lacunarity = 2.0 #default 2.0
	groundNoise.fractal_gain = 0.8 #default 0.5

func getPoint(x,y)->float:
	var rep:float = 0
	rep += baseNoise.get_noise_2d(x,y) #DONE
	rep += (max(montainNoise.get_noise_2d(x,y),.2)-.2)
	rep += (max(hillNoise.get_noise_2d(x,y),.0))*.2
	rep += groundNoise.get_noise_2d(x,y)*.02 #DONE
	return rep
