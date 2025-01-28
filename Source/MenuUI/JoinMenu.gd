class_name JoinMenu extends PanelContainer

@onready var pseudoLine:LineEdit = $MarginContainer/VBoxContainer/GridContainer/PseudoLine
@onready var passwordLine:LineEdit = $MarginContainer/VBoxContainer/GridContainer/PasswordLine
@onready var IPLine:LineEdit = $MarginContainer/VBoxContainer/GridContainer/IPLine

@onready var joinButton:Button = $MarginContainer/VBoxContainer/JoinButton

signal join(pseudo:String, password:String, ipAdress:String)
signal goBack()

func init():
	pseudoLine.clear()
	passwordLine.clear()
	IPLine.clear()
	joinButton.disabled = true

func validateJoin()-> void:
	joinButton.disabled = !(!pseudoLine.text.is_empty() && IPLine.text.is_valid_ip_address())

func _on_pseudo_line_text_changed(new_text: String) -> void:
	validateJoin()
func _on_ip_line_text_changed(new_text: String) -> void:
	validateJoin()

func _on_join_button_pressed() -> void:
	join.emit(pseudoLine.text, passwordLine.text, IPLine)
func _on_go_back_button_pressed() -> void:
	goBack.emit()
