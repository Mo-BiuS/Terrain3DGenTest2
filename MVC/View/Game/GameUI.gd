class_name GameUI extends CanvasLayer

@onready var chunkPosLabel:Label = $VBoxContainer/ChunkPosLabel
@onready var fpsLabel:Label = $VBoxContainer/FpsLabel
@onready var playerPosLabel:Label = $VBoxContainer/PlayerPosLabel

func _process(delta: float) -> void:
	fpsLabel.text = "FPS : "+str(Engine.get_frames_per_second())

func setChunkPos(x:int, y:int, details:int):
	chunkPosLabel.text = "Chunk | x:"+str(x)+", y:"+str(y)+" | Details : "+str(details)

func setPlayerPos(x:int, y:int, z:int):
	playerPosLabel.text = "Player pos | x:"+str(x)+", y:"+str(y)+", z:"+str(z)
