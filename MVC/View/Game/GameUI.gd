class_name GameUI extends CanvasLayer

@onready var chunkPosLabel:Label = $VBoxContainer/ChunkPosLabel
@onready var fpsLabel:Label = $VBoxContainer/FpsLabel

func _process(delta: float) -> void:
	fpsLabel.text = "FPS : "+str(Engine.get_frames_per_second())

func setChunkPos(x:int, y:int):
	chunkPosLabel.text = "Chunk : "+str(x)+","+str(y)
