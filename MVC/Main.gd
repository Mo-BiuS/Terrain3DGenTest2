class_name Main extends Node

var noiseGenerator:NoiseGenerator = NoiseGenerator.new()

var posX = 0;
var posY = 0;
var rx = 128;
var ry = 128;
var scaleHeight = 2048*2
var scaleWidth = 128

func _ready() -> void:
	noiseGenerator.setSeed(randi())
	noiseGenerator.genNoiseMap(posX,posY,rx,ry,1)
	genTerrain()
	

func genTerrain() -> void:
	var surface_tool = SurfaceTool.new();
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES);
	var v = 0;
	
	for x in range(rx*2):
		for y in range(ry*2):
			var grassColor:Color = Color(.2, randf_range(.6,1), .2)
			var sandColor:Color = Color(randf_range(.80,.90),randf_range(.80,.90),randf_range(.60,.70))
			var montainColor:Color = getGreyColor(randf_range(.2,.6))
			
			for i in [Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(0,1)]:
				var value:float = noiseGenerator.map.get_pixel(x+i.x,y+i.y).r
				
				if(value < .4):surface_tool.set_color(sandColor)
				elif(value < .6):surface_tool.set_color(grassColor)
				else:surface_tool.set_color(montainColor)
				
				surface_tool.add_vertex(Vector3((posX-rx+x+i.x)*scaleWidth, (value-.5)*scaleHeight, (posY-ry+y+i.y)*scaleWidth));
			
			surface_tool.add_index(v);
			surface_tool.add_index(v+1);
			surface_tool.add_index(v+2);
			
			surface_tool.add_index(v);
			surface_tool.add_index(v+2);
			surface_tool.add_index(v+3);
			v+=4
	
	surface_tool.generate_normals()
	var mesh:MeshInstance3D = MeshInstance3D.new()
	mesh.mesh = surface_tool.commit()
	mesh.material_overlay = StandardMaterial3D.new()
	mesh.material_overlay.vertex_color_use_as_albedo = true
	mesh.create_convex_collision()
	
	add_child(mesh)

func getGreyColor(value:float)->Color:
	return Color(value,value,value)
