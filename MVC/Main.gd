class_name Main extends Node

var noiseGenerator:NoiseGenerator = NoiseGenerator.new()

var posX = 0;
var posY = 0;
var rx = 128;
var ry = 128;
var scaleHeight = 1024
var scaleWidth = 32

func _ready() -> void:
	noiseGenerator.setSeed(randi())

func getGreyColor(value:float)->Color:
	return Color(value,value,value)


func _on_character_body_3d_changed_chunk() -> void:
	$CanvasLayer.setPos($CharacterBody3D.cPos.x,$CharacterBody3D.cPos.z)
	$MapHandler.genChunkRadius($CharacterBody3D.cPos.x,$CharacterBody3D.cPos.z,8)
