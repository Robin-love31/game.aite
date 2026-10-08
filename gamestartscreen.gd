extends CanvasLayer

func _ready():
	$ColorRect/VBoxContainer/Button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	# 隐藏开始界面
	hide()
	
	# 【关键】解除游戏暂停，让游戏跑起来！
	get_tree().paused = false
