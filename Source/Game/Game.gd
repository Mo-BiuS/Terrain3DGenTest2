class_name Game extends Node

@onready var mapHandler:MapHandler = $MapHandler
@onready var playerHandler:PlayerHandler = $PlayerHandler
@onready var gui:GameUI = $GameUI
@onready var player = $PlayerHandler/Player

var seed:int

func _ready() -> void:
	mapHandler.changedChunk(0,0)

func _process(_delta: float) -> void:
	gui.setPlayerPos(player.position.x,player.position.y,player.position.z)

func changedChunk(x:int, y:int):
	gui.setChunkPos(x,y,mapHandler.getChunkDetailsLevel(x,y))
	mapHandler.changedChunk(x,y)
