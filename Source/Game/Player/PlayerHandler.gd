class_name PlayerHandler extends Node

@onready var game:Game = $".."
var playerPacked:PackedScene = preload("res://Source/Game/Player/Player.tscn")

func _ready() -> void:
	multiplayer.peer_disconnected.connect(removePlayer)

func addPlayer(id:int)->Player:
	var player:Player = playerPacked.instantiate()
	player.id = id
	add_child(player,true)
	return player

func removePlayer(id:int)->void:
	for i in get_children():
		if i is Player && i.id == id:i.queue_free()
	

func _on_character_body_3d_changed_chunk(posX: int, posY: int) -> void:
	game.changedChunk(posX,posY)
