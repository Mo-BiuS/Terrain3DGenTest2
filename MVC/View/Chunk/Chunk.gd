class_name Chunk extends Node3D

var noiseGenerator:NoiseGenerator = NoiseGenerator.new()

@onready var terrainMesh:MeshInstance3D

const SIZE = 128
const SCALE_HEIGHT = 512
const SCALE_WIDTH = 2

var posX:int
var posY:int
var dist:float
var oldDetails:int = -1
var newDetails:int = 0

var unload:bool

var genThread:Thread = Thread.new()

func genTerrain(seed:int)->void:
	if(genThread.is_alive()):
		return
	
	calcNewDetails()
	if(oldDetails == newDetails):return
	oldDetails = newDetails
	
	if(terrainMesh != null):
		terrainMesh.queue_free()
		terrainMesh = null
	
	genThread = Thread.new()
	genThread.start(genTerrainThread.bind(seed))

func genTerrainThread(seed:int)->void:
	
	var surface_tool = SurfaceTool.new();
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES);
	var v = 0;
	
	noiseGenerator.setSeed(seed)
	noiseGenerator.genNoiseMap(posX/SCALE_WIDTH,posY/SCALE_WIDTH, SIZE*2+1, SIZE*2+1)
	
	var map:Image = noiseGenerator.map
	for x in range(SIZE/newDetails):
		for y in range(SIZE/newDetails):
			var px = x*newDetails
			var py = y*newDetails
			var grassColor:Color = Color(.2, randf_range(.6,1), .2)
			var sandColor:Color = Color(randf_range(.80,.90),randf_range(.80,.90),randf_range(.60,.70))
			var c = randf_range(.2,.6)
			var montainColor:Color = Color(c,c,c)
				
			for i in [Vector2(0,0),Vector2(newDetails,0),Vector2(newDetails,newDetails),Vector2(0,newDetails)]:
				var value:float = map.get_pixel(px+i.x,py+i.y).r
				
				if(value < .5):surface_tool.set_color(sandColor)
				elif(value < .7):surface_tool.set_color(grassColor)
				else:surface_tool.set_color(montainColor)
				
				surface_tool.add_vertex(Vector3((px+i.x)*SCALE_WIDTH, (value-.5)*SCALE_HEIGHT, (py+i.y)*SCALE_WIDTH));
			
			surface_tool.add_index(v);
			surface_tool.add_index(v+1);
			surface_tool.add_index(v+2);
			
			surface_tool.add_index(v);
			surface_tool.add_index(v+2);
			surface_tool.add_index(v+3);
			v+=4
	
	surface_tool.generate_normals()
	
	terrainMesh = MeshInstance3D.new()
	terrainMesh.material_overlay = StandardMaterial3D.new()
	terrainMesh.material_overlay.vertex_color_use_as_albedo = true
	terrainMesh.mesh = surface_tool.commit()
	terrainMesh.create_trimesh_collision()
	
	if(is_instance_valid(self)):
		call_deferred("add_child",terrainMesh)

func setPos(x:int,y:int)->void:
	posX = x*SIZE*SCALE_WIDTH
	posY = y*SIZE*SCALE_WIDTH
	position = Vector3(posX,0,posY)
func getPosition()->Vector2i:
	return Vector2i(posX,posY)/SIZE/SCALE_WIDTH
func calcNewDetails():
	if dist <= 1.5: newDetails = 1
	if dist <= 3: newDetails = 2
	if dist <= 6: newDetails = 4
	else: newDetails = 32
