extends CanvasLayer
func _ready():
	$ColorRect/VBoxContainer/Button.pressed.connect(_on_button_pressed)
func _on_button_pressed():
	Global.coin_count = 0
	hide()
	get_tree().reload_current_scene()
