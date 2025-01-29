class_name UpnpFailedMenu extends PanelContainer

signal returnToMenu

func _on_return_to_menu_pressed() -> void:
	returnToMenu.emit()
