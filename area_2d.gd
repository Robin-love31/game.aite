extends Area2D

# 在编辑器里暴露出来，方便你以后调数值（比如蓝钻值多少分）
@export var gem_value: int = 1 

func _ready():
	# 连接碰撞信号
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.has_blue_gem = true # ✅ 改成写入 Global
		queue_free()
