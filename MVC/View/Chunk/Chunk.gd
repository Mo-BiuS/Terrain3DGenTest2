class_name Chunk extends Node3D

var noiseGenerator:NoiseGenerator = NoiseGenerator.new()

const SIZE = 32
const SCALE_HEIGHT = 1024
const SCALE_WIDTH = 16

var posX:int
var posY:int

var neighboor:Array[Chunk]

var unload:bool

var genThread:Thread = Thread.new()
var isTerrainGen = false

func _process(delta: float) -> void:
	if(isTerrainGen && genThread.is_alive()):
		genThread.wait_to_finish()

func genTerrain()->void:
	if(!isTerrainGen):
		genThread.start(genTerrainThread.bind())

func genTerrainThread()->void:
	var surface_tool = SurfaceTool.new();
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES);
	var v = 0;
	
	noiseGenerator.genNoiseMap(posX/SCALE_WIDTH,posY/SCALE_WIDTH, SIZE+1, SIZE+1)
	var map:Image = noiseGenerator.map
	
	for x in range(SIZE):
		for y in range(SIZE):
			var grassColor:Color = Color(.2, randf_range(.6,1), .2)
			var sandColor:Color = Color(randf_range(.80,.90),randf_range(.80,.90),randf_range(.60,.70))
			var c = randf_range(.2,.6)
			var montainColor:Color = Color(c,c,c)
			
			for i in [Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(0,1)]:
				var value:float = map.get_pixel(x+i.x,y+i.y).r
				
				if(value < .5):surface_tool.set_color(sandColor)
				elif(value < .7):surface_tool.set_color(grassColor)
				else:surface_tool.set_color(montainColor)
				
				surface_tool.add_vertex(Vector3((x+i.x)*SCALE_WIDTH, (value-.5)*SCALE_HEIGHT, (y+i.y)*SCALE_WIDTH));
			
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
	
	if(is_instance_valid(self) && is_instance_valid(mesh)):
		call_deferred("add_child",mesh)
	isTerrainGen = true

func setPos(x:int,y:int)->void:
	posX = x*SIZE*SCALE_WIDTH
	posY = y*SIZE*SCALE_WIDTH
	position = Vector3(posX,0,posY)
func getPosition()->Vector2i:
	return Vector2i(posX,posY)/SIZE/SCALE_WIDTH
func setNeighboor(n:Array[Chunk])->void:
	neighboor = n
