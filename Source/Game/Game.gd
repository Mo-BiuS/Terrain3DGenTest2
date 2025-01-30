class_name Game extends Node3D

@onready var mapHandler:MapHandler = $MapHandler
@onready var playerHandler:PlayerHandler = $PlayerHandler
@onready var gui:GameUI = $GameUI

func reset()->void:
	mapHandler.reset()
	playerHandler.reset()

func addServerPlayer()->void:
	mapHandler.setPlayerFocus(playerHandler.addPlayer(1))
	mapHandler.changedChunk(0,0)
func addPlayer(id:int)->void:
	playerHandler.addPlayer(id)
func isGameLoaded()->bool:
	return mapHandler.isMapLoaded()
func changedChunk(x:int, y:int):
	mapHandler.changedChunk(x,y)

func _on_player_spawner_spawned(node: Node) -> void:
	if(node is Player && node.id == multiplayer.get_unique_id()):
		mapHandler.setPlayerFocus(node)
		mapHandler.changedChunk(0,0)
