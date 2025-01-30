class_name Player extends CharacterBody3D

const SPEED = 24 #Normal 24
const JUMP_VELOCITY = 32

var cPos:Vector3i
@export var id:int = -1

signal changedChunk(posX:int, posY:int)

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity: float = 64
@onready var neck:Node3D = $Neck
@onready var camera:Camera3D = $Neck/Camera3d
@onready var cameraRayCast:RayCast3D = $Neck/RayCast3D
@onready var meshList:Node3D = $MeshList
@onready var nameLabel:Label3D = $NameLabel

func _ready():
	camera.current = (id == multiplayer.get_unique_id())
	nameLabel.visible = (id != multiplayer.get_unique_id())
	if multiplayer.is_server():nameLabel.text = G_DATA.playerNameDico[id]

func _process(delta: float) -> void:
	cameraRayCast.force_raycast_update()
	if cameraRayCast.is_colliding():
		camera.position.z = cameraRayCast.to_local(cameraRayCast.get_collision_point()).z-1
	else:
		camera.position.z = 8

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotation.y = neck.rotation.y - event.relative.x * 0.01
			neck.rotation.x = neck.rotation.x - event.relative.y * 0.005
			neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-60), deg_to_rad(30))


func _physics_process(delta: float) -> void:
	if(id == multiplayer.get_unique_id()):
		if not is_on_floor():
			velocity.y -= gravity * delta
		if Input.is_action_pressed("space") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		move_and_slide()
		
		var nPos:Vector3 = position/(Chunk.SIZE*Chunk.SCALE_WIDTH)
		if(nPos.x < 0):nPos.x-=1
		if(nPos.z < 0):nPos.z-=1
		var iPos:Vector3i =  Vector3i(nPos)
		
		if iPos != cPos:
			changedChunk.emit(iPos.x, iPos.z)
		cPos = iPos
		
		if(position.y <= -256):
			position.y = 256
		
		sendPos.rpc(position)

@rpc("any_peer","call_remote")
func sendPos(pos:Vector3):
	position = pos
