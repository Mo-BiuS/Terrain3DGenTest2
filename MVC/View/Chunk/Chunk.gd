class_name Chunk extends Node3D

var noiseGenerator:NoiseGenerator = NoiseGenerator.new()

@onready var terrainMeshInner:MeshInstance3D
@onready var terrainMeshOuter:MeshInstance3D

const SIZE = 128
const SCALE_HEIGHT = 512
const SCALE_WIDTH = 2

var grassColor:Color = Color(.2, .6, .2)
var sandColor:Color = Color(.8,.8,.6)
var montainColor:Color = Color(.4,.4,.4)

var posX:int
var posY:int
var oldDetails:int = -1
var newDetails:int = 0

var neighbors:Array[Chunk] = [null,null,null,null]
var neighborsDifferentDetails:Array[bool] = [false,false,false,false]

var unload:bool

var baseMap:Image
var hillMap:Image

var genThread:Thread = Thread.new()

func genTerrain(seed:int)->void:
	noiseGenerator.setSeed(seed)
	if(baseMap == null):baseMap = noiseGenerator.genBaseMap(posX/SCALE_WIDTH,posY/SCALE_WIDTH, SIZE+1, SIZE+1)
	if(hillMap == null):hillMap = noiseGenerator.genHillMap(posX/SCALE_WIDTH,posY/SCALE_WIDTH, SIZE+1, SIZE+1)
	
	if(oldDetails != newDetails):
		genTerrainInner()
		genTerrainOuter()
	elif(neighborsDifferentDetails != getNeighborDiff()):
		genTerrainOuter()
	oldDetails = newDetails

func genTerrainInner()->void:
	var surface_tool = SurfaceTool.new();
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES);
	var v = 0;
	
	for x in range(1,SIZE/newDetails-1):
		for y in range(1,SIZE/newDetails-1):
			var px = x*newDetails
			var py = y*newDetails
			
			for i in [Vector2i(0,0),Vector2i(newDetails,0),Vector2i(newDetails,newDetails),Vector2i(0,newDetails)]:
				var value:float = getMapValue(px+i.x,py+i.y)
				
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
	
	var oldterrainMeshInner = terrainMeshInner
	
	terrainMeshInner = MeshInstance3D.new()
	terrainMeshInner.material_overlay = StandardMaterial3D.new()
	terrainMeshInner.material_overlay.vertex_color_use_as_albedo = true
	terrainMeshInner.mesh = surface_tool.commit()
	terrainMeshInner.create_trimesh_collision()
	
	
	if(is_instance_valid(self)):
		call_deferred("add_child",terrainMeshInner)
		if(oldterrainMeshInner!=null):oldterrainMeshInner.queue_free()

func genTerrainOuter()->void:
	neighborsDifferentDetails = [false,false,false,false]
	var surface_tool = SurfaceTool.new();
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES);
	var v = 0;
	
	for x in range(SIZE/newDetails):
		for y in range(SIZE/newDetails):
			if(x == 0 || y == 0 || x == int(SIZE/newDetails)-1 || y == int(SIZE/newDetails)-1):
				var px = x*newDetails
				var py = y*newDetails
				
				for i in [Vector2i(0,0),Vector2i(newDetails,0),Vector2i(newDetails,newDetails),Vector2i(0,newDetails)]:
					var value:float = 0.0
					
					if(px + i.x == 0 && neighbors[0] != null && newDetails < neighbors[0].newDetails):
						neighborsDifferentDetails[0] = true
						var nd = neighbors[0].newDetails
						value = lerp(getMapValue(0,int((py+i.y)/nd)*nd),getMapValue(0,int((py+i.y)/nd+1)*nd),float((py+i.y)%nd)/nd)
					elif(px + i.x == SIZE && neighbors[2] != null && newDetails < neighbors[2].newDetails):
						neighborsDifferentDetails[2] = true
						var nd = neighbors[2].newDetails
						value = lerp(getMapValue(SIZE,int((py+i.y)/nd)*nd),getMapValue(SIZE,int((py+i.y)/nd+1)*nd),float((py+i.y)%nd)/nd)
					elif(py + i.y == 0 && neighbors[3] != null && newDetails < neighbors[3].newDetails):
						neighborsDifferentDetails[3] = true
						var nd = neighbors[3].newDetails
						value = lerp(getMapValue(int((px+i.x)/nd)*nd,0),getMapValue(int((px+i.x)/nd+1)*nd,0),float((px+i.x)%nd)/nd)
					elif(py + i.y == SIZE && neighbors[1] != null && newDetails < neighbors[1].newDetails):
						neighborsDifferentDetails[1] = true
						var nd = neighbors[1].newDetails
						value = lerp(getMapValue(int((px+i.x)/nd)*nd,SIZE),getMapValue(int((px+i.x)/nd+1)*nd,SIZE),float((px+i.x)%nd)/nd)
					else:
						value = getMapValue(px+i.x,py+i.y)
					
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
	
	var oldterrainMeshOuter = terrainMeshOuter
	
	terrainMeshOuter = MeshInstance3D.new()
	terrainMeshOuter.material_overlay = StandardMaterial3D.new()
	terrainMeshOuter.material_overlay.vertex_color_use_as_albedo = true
	terrainMeshOuter.mesh = surface_tool.commit()
	terrainMeshOuter.create_trimesh_collision()
	
	if(is_instance_valid(self)):
		call_deferred("add_child",terrainMeshOuter)
		if(oldterrainMeshOuter!=null):oldterrainMeshOuter.queue_free()

func getNeighborDiff()->Array[bool]:
	var rep:Array[bool] = [false,false,false,false]
	if(neighbors[0] != null): rep[0] = newDetails < neighbors[0].newDetails
	if(neighbors[1] != null): rep[1] = newDetails < neighbors[1].newDetails
	if(neighbors[2] != null): rep[2] = newDetails < neighbors[2].newDetails
	if(neighbors[3] != null): rep[3] = newDetails < neighbors[3].newDetails
	return rep
func getMapValue(posX, posY)->float:
	return baseMap.get_pixel(posX,posY).r + hillMap.get_pixel(posX, posY).r*.1

func setPos(x:int,y:int)->void:
	posX = x*SIZE*SCALE_WIDTH
	posY = y*SIZE*SCALE_WIDTH
	position = Vector3(posX,0,posY)
func getPosition()->Vector2i:
	return Vector2i(posX,posY)/SIZE/SCALE_WIDTH
func calcNewDetails(dist:float):
	if dist <= 1.5: newDetails = 1
	elif dist <= 3: newDetails = 4
	else: newDetails = 32
