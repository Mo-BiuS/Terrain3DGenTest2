class_name Main extends Node

var noiseGenerator:NoiseGenerator = NoiseGenerator.new()

var posX = 0;
var posY = 0;

func _ready() -> void:
	noiseGenerator.setSeed(randi())
	#noiseGenerator.genNoiseMap(posX,posY,128,128,1)
	noiseGenerator.genMinimap(posX,posY,512,512)
	add_child(noiseGenerator.minimap)
	noiseGenerator.minimap.scale = Vector2(8,8)

func _process(delta: float) -> void:
	var regen = false
	
	if(Input.is_action_pressed("n")):
		posY-=4
		regen=true
	if(Input.is_action_pressed("e")):
		posX+=4
		regen=true
	if(Input.is_action_pressed("s")):
		posY+=4
		regen=true
	if(Input.is_action_pressed("w")):
		posX-=4
		regen=true
	
	if(regen):
		#noiseGenerator.genNoiseMap(posX,posY,128,128,1)
		noiseGenerator.genMinimap(posX,posY,512,512)
		add_child(noiseGenerator.minimap)
		noiseGenerator.minimap.scale = Vector2(2,2)
	
