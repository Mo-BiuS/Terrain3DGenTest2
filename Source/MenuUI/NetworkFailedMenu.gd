class_name NetworkFailedMenu extends PanelContainer

signal returnToMenu

@onready var failedMessage:Label = $MarginContainer/VBoxContainer/FailedMessage

func setText(text:String)->void:
	failedMessage.text = text
func _on_return_to_menu_pressed() -> void:
	returnToMenu.emit()
