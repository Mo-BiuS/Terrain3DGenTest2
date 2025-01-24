extends CharacterBody3D


const SPEED = 24 #Normal 24
const JUMP_VELOCITY = 32

var cPos:Vector3i

signal changedChunk(posX:int, posY:int)

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity: float = 64
@onready var neck := $Neck
@onready var camera := $Neck/Camera3d

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotation.y = neck.rotation.y - event.relative.x * 0.01
			neck.rotation.x = neck.rotation.x - event.relative.y * 0.005
			#neck.rotation.z = 0
			neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func _physics_process(delta: float) -> void:
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
	
	if(position.y <= -128):
		position.y = 128
