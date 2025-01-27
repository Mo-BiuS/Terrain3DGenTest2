class_name PlayerHandler extends Node

@onready var game:Game = $".."

func _on_character_body_3d_changed_chunk(posX: int, posY: int) -> void:
	game.changedChunk(posX,posY)
