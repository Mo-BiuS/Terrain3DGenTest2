class_name GameUI extends CanvasLayer

@onready var chunkPosLabel:Label = $VBoxContainer/ChunkPosLabel
@onready var fpsLabel:Label = $VBoxContainer/FpsLabel
@onready var playerPosLabel:Label = $VBoxContainer/PlayerPosLabel

func _process(_delta: float) -> void:
	fpsLabel.text = "FPS : "+str(Engine.get_frames_per_second())
	setChunkPos()
	setPlayerPos()

func setChunkPos():
	if(G_DATA.playerFocus == null):playerPosLabel.hide()
	else:
		playerPosLabel.show()
		var p:Vector3i = G_DATA.playerFocus.cPos
		chunkPosLabel.text = "Chunk | x:"+str(p.x)+", y:"+str(p.y)

func setPlayerPos():
	if(G_DATA.playerFocus == null):playerPosLabel.hide()
	else:
		playerPosLabel.show()
		var p:Vector3i = G_DATA.playerFocus.position
		playerPosLabel.text = "Player pos | x:"+str(p.x)+", y:"+str(p.y)+", z:"+str(p.z)
