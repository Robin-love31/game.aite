extends Area2D
@export var target_wall: StaticBody2D
func _ready():
	body_entered.connect(_on_body_entered)
func _on_body_entered(body):
	if body.is_in_group("player"):
		print("✅ 玩家踩下了按钮！")
		
		# 如果墙壁已经连线了，就让它消失
		if target_wall:
			target_wall.disappear() # 调用墙壁的消失函数
			print("✅ 墙壁的 disappear 函数已调用")
		else:
			print("❌ 错误：忘记在检查器里给 Target Wall 赋值了！")
	else:
		pass
