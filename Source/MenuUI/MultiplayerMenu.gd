class_name MultiplayerMenu extends PanelContainer

signal host;
signal join;

func _on_host_button_pressed() -> void:
	host.emit()
func _on_join_button_pressed() -> void:
	join.emit()
