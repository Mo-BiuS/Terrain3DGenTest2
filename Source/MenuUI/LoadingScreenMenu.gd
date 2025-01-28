class_name LoadingScreenMenu extends PanelContainer

@onready var loadingImageControl:Control = $MarginContainer/Control
@onready var textLabel:Label = $MarginContainer/PanelContainer/MarginContainer/TextLabel

func _process(delta: float) -> void:
	loadingImageControl.rotation_degrees+=.1

func setText(text:String) -> void:
	textLabel.text = text
