class_name HostMenu extends PanelContainer

@onready var pseudoLine:LineEdit = $MarginContainer/VBoxContainer/GridContainer/PseudoLine
@onready var passwordLine:LineEdit = $MarginContainer/VBoxContainer/GridContainer/PasswordLine
@onready var seedLine:LineEdit = $MarginContainer/VBoxContainer/GridContainer/SeedLine
@onready var upnpCheck:CheckBox = $MarginContainer/VBoxContainer/GridContainer/UPNPCheck

@onready var hostButton:Button = $MarginContainer/VBoxContainer/HostButton

signal host(pseudo:String, password:String, seed:int, upnp:bool)
signal goBack()

func init():
	pseudoLine.clear()
	passwordLine.clear()
	seedLine.clear()
	upnpCheck.button_pressed = false
	hostButton.disabled = true

func validateHost()-> void:
	hostButton.disabled = !(!pseudoLine.text.is_empty())
func _on_pseudo_line_text_changed(new_text: String) -> void:
	validateHost()

func _on_host_button_pressed() -> void:
	host.emit(pseudoLine.text, passwordLine.text, seedLine.text.to_int(), upnpCheck.button_pressed)
func _on_go_back_button_pressed() -> void:
	goBack.emit()
