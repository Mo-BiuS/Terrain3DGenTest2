class_name Minimap extends MarginContainer

@onready var textureRect:TextureRect = $TextureRect
@onready var arrow= $Control
var noiseGen:NoiseGenerator = NoiseGenerator.new()

var radius:int = 96
var mapScale:int = 4

var water:Color = Color.BLUE
var grass:Color = Color.GREEN
var sand:Color = Color.ANTIQUE_WHITE

var init:bool = false
var oldP:Vector3i = Vector3i(0,0,0)

func _ready() -> void:
	var img:Image = Image.create_empty(radius*2,radius*2, false, Image.FORMAT_RGBAH)
	textureRect.texture = ImageTexture.create_from_image(img)

func refresh()->void:
	if(G_DATA.playerFocus == null):hide()
	else:
		arrow.rotation=-G_DATA.playerFocus.getCameraRotation()
		var p:Vector3i = G_DATA.playerFocus.position/Chunk.SCALE_WIDTH
		if(oldP != p):
			oldP = p
			if(!init):
				noiseGen.init(G_DATA.seed,p.x,p.z)
				init = true
			else:
				noiseGen.setOffset(p.x,p.z)
			
			var img:Image = textureRect.texture.get_image()
			
			for x in range(radius*2):
				for y in range(radius*2):
					if(sqrt(pow(x-radius,2)+pow(y-radius,2)) <= radius):
						var value:float = noiseGen.getPoint((x-radius) * mapScale, (y-radius) * mapScale)
						var color:Color
						
						if value <= 0:color = water
						elif value <= .01:color = sand
						else:color = grass
						
						img.set_pixel(x, y, color)
			textureRect.texture = ImageTexture.create_from_image(img)
			show()
